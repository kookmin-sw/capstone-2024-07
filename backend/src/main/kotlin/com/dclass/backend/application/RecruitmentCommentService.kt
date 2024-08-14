package com.dclass.backend.application

import com.dclass.backend.application.dto.CreateRecruitmentCommentRequest
import com.dclass.backend.application.dto.DeleteRecruitmentCommentRequest
import com.dclass.backend.application.dto.RecruitmentCommentReplyWithUserResponse
import com.dclass.backend.application.dto.RecruitmentCommentResponse
import com.dclass.backend.application.dto.RecruitmentCommentScrollRequest
import com.dclass.backend.application.dto.RecruitmentCommentsResponse
import com.dclass.backend.application.dto.UpdateRecruitmentCommentRequest
import com.dclass.backend.domain.recruitment.RecruitmentRepository
import com.dclass.backend.domain.recruitment.findByIdOrThrow
import com.dclass.backend.domain.recruitmentanonymous.RecruitmentAnonymous
import com.dclass.backend.domain.recruitmentanonymous.RecruitmentAnonymousRepository
import com.dclass.backend.domain.recruitmentcomment.RecruitmentCommentRepository
import com.dclass.backend.domain.recruitmentcomment.getByIdAndUserIdOrThrow
import com.dclass.backend.domain.recruitmentreply.RecruitmentReplyRepository
import com.dclass.backend.domain.userblock.UserBlockRepository
import com.dclass.backend.exception.comment.CommentException
import com.dclass.backend.exception.comment.CommentExceptionType
import org.springframework.orm.ObjectOptimisticLockingFailureException
import org.springframework.retry.annotation.Backoff
import org.springframework.retry.annotation.Retryable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class RecruitmentCommentService(
    private val commentRepository: RecruitmentCommentRepository,
    private val replyRepository: RecruitmentReplyRepository,
    private val recruitmentRepository: RecruitmentRepository,
    private val validator: CommentReplyValidator,
    private val userBlockRepository: UserBlockRepository,
    private val anonymousRepository: RecruitmentAnonymousRepository
) {
    @Retryable(
        ObjectOptimisticLockingFailureException::class,
        maxAttempts = 3,
        backoff = Backoff(delay = 500),
    )
    fun create(userId: Long, request: CreateRecruitmentCommentRequest): RecruitmentCommentResponse {
        val recruitment = recruitmentRepository.findByIdOrThrow(request.recruitmentId)
        validator.validate(userId, recruitment.departmentId)
        val comment = commentRepository.save(request.toEntity(userId))

        if (request.isAnonymous && !anonymousRepository.existsByUserIdAndRecruitmentId(userId, recruitment.id)) {
            anonymousRepository.save(RecruitmentAnonymous(userId, recruitment.id))
        }

        recruitment.increaseCommentReplyCount()

        return RecruitmentCommentResponse(comment)
    }

    fun update(userId: Long, request: UpdateRecruitmentCommentRequest) {
        val comment = commentRepository.getByIdAndUserIdOrThrow(request.commentId, userId)

        comment.changeContent(request.content)
    }

    @Retryable(
        ObjectOptimisticLockingFailureException::class,
        maxAttempts = 3,
        backoff = Backoff(delay = 500),
    )
    fun delete(userId: Long, request: DeleteRecruitmentCommentRequest) {
        val comment = commentRepository.getByIdAndUserIdOrThrow(request.commentId, userId)
        if (comment.isDeleted()) throw CommentException(CommentExceptionType.DELETED_COMMENT)
        commentRepository.delete(comment)

        val recruitment = recruitmentRepository.findByIdOrThrow(comment.recruitmentId)
        recruitment.decreaseCommentReplyCount()
    }

    @Transactional(readOnly = true)
    fun findAll(userId: Long, request: RecruitmentCommentScrollRequest): RecruitmentCommentsResponse {
        val blockedUserIds = userBlockRepository.findByBlockerUserId(userId).map { it.blockedUserId }
        val anonymousList = anonymousRepository.findByRecruitmentId(request.recruitmentId)
        val comments = commentRepository.findRecruitmentCommentWithUserByRecruitmentId(request)
            .map { it.apply { isBlockedUser = blockedUserIds.contains(it.userId) } }
            .map {
                it.apply {
                    this.userInformation.updateAnonymous(
                        getIndex(anonymousList, this.userId),
                        this.isAnonymous,
                        this.userId == userId,
                    )
                }
            }

        val commentIds = comments.map { it.id }
        val replies = replyRepository.findRecruitmentRepliesWithUserByCommentIdIn(commentIds)
            .map { it.apply { isBlockedUser = blockedUserIds.contains(it.userId) } }
            .map {
                it.apply {
                    this.userInformation.updateAnonymous(
                        getIndex(anonymousList, this.userId),
                        this.isAnonymous,
                        this.userId == userId,
                    )
                }
            }
            .groupBy { it.commentId }
        val data = comments.map {
            RecruitmentCommentReplyWithUserResponse(
                it,
                replies[it.id] ?: emptyList(),
            )
        }

        return RecruitmentCommentsResponse.of(data, request.size)
    }

    private fun getIndex(anonymousList: List<RecruitmentAnonymous>, userId: Long): Int {
        return anonymousList.indexOfFirst { it.userId == userId }
    }
}
