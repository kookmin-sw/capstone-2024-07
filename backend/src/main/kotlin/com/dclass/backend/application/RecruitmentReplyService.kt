package com.dclass.backend.application

import com.dclass.backend.application.dto.CreateRecruitmentReplyRequest
import com.dclass.backend.application.dto.DeleteRecruitmentReplyRequest
import com.dclass.backend.application.dto.RecruitmentReplyResponse
import com.dclass.backend.application.dto.UpdateRecruitmentReplyRequest
import com.dclass.backend.domain.recruitment.RecruitmentRepository
import com.dclass.backend.domain.recruitment.findByIdOrThrow
import com.dclass.backend.domain.recruitmentanonymous.RecruitmentAnonymousRepository
import com.dclass.backend.domain.recruitmentcomment.RecruitmentCommentRepository
import com.dclass.backend.domain.recruitmentcomment.getByIdOrThrow
import com.dclass.backend.domain.recruitmentreply.RecruitmentReplyRepository
import com.dclass.backend.domain.recruitmentreply.getByIdAndUserIdOrThrow
import com.dclass.backend.exception.comment.CommentException
import com.dclass.backend.exception.comment.CommentExceptionType
import org.springframework.orm.ObjectOptimisticLockingFailureException
import org.springframework.retry.annotation.Backoff
import org.springframework.retry.annotation.Retryable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class RecruitmentReplyService(
    private val replyRepository: RecruitmentReplyRepository,
    private val recruitmentRepository: RecruitmentRepository,
    private val commentRepository: RecruitmentCommentRepository,
    private val validator: CommentReplyValidator,
    private val anonymousRepository: RecruitmentAnonymousRepository,
) {
    @Retryable(
        ObjectOptimisticLockingFailureException::class,
        maxAttempts = 3,
        backoff = Backoff(delay = 500),
    )
    fun create(userId: Long, request: CreateRecruitmentReplyRequest): RecruitmentReplyResponse {
        val comment = commentRepository.getByIdOrThrow(request.commentId)

        if (comment.isDeleted()) {
            throw CommentException(CommentExceptionType.DELETED_COMMENT)
        }

        val recruitment = recruitmentRepository.findByIdOrThrow(comment.recruitmentId)

        validator.validate(userId, recruitment.departmentId)

        val reply = replyRepository.save(request.toEntity(userId))

        if (request.isAnonymous && !anonymousRepository.existsByUserIdAndRecruitmentId(userId, recruitment.id)) {
            anonymousRepository.save(request.toAnonymousEntity(userId, recruitment.id))
        }

        comment.increaseReplyCount()
        recruitment.increaseCommentReplyCount()

        return RecruitmentReplyResponse(reply)
    }

    fun update(userId: Long, request: UpdateRecruitmentReplyRequest) {
        val reply = replyRepository.getByIdAndUserIdOrThrow(request.replyId, userId)
        reply.changeContent(request.content)
    }

    @Retryable(
        ObjectOptimisticLockingFailureException::class,
        maxAttempts = 3,
        backoff = Backoff(delay = 500),
    )
    fun delete(userId: Long, request: DeleteRecruitmentReplyRequest) {
        val reply = replyRepository.getByIdAndUserIdOrThrow(request.replyId, userId)
        val comment = commentRepository.getByIdOrThrow(reply.recruitmentCommentId)
        val recruitment = recruitmentRepository.findByIdOrThrow(comment.recruitmentId)

        comment.decreaseReplyCount()
        recruitment.decreaseCommentReplyCount()

        replyRepository.delete(reply)
    }
}
