package com.dclass.backend.application

import com.dclass.backend.application.dto.CommentReplyResponse
import com.dclass.backend.application.dto.CommentReplyWithUserResponse
import com.dclass.backend.application.dto.CommentResponse
import com.dclass.backend.application.dto.CommentScrollPageRequest
import com.dclass.backend.application.dto.CommentsResponse
import com.dclass.backend.application.dto.CreateCommentRequest
import com.dclass.backend.application.dto.DeleteCommentRequest
import com.dclass.backend.application.dto.LikeCommentRequest
import com.dclass.backend.application.dto.UpdateCommentRequest
import com.dclass.backend.domain.anonymous.Anonymous
import com.dclass.backend.domain.anonymous.AnonymousRepository
import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.comment.getByIdOrThrow
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.community.findByIdOrThrow
import com.dclass.backend.domain.notification.NotificationEvent
import com.dclass.backend.domain.post.Post
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.findByIdOrThrow
import com.dclass.backend.domain.reply.ReplyRepository
import com.dclass.backend.domain.userblock.UserBlock
import com.dclass.backend.domain.userblock.UserBlockRepository
import com.dclass.backend.exception.comment.CommentException
import com.dclass.backend.exception.comment.CommentExceptionType
import org.springframework.context.ApplicationEventPublisher
import org.springframework.orm.ObjectOptimisticLockingFailureException
import org.springframework.retry.annotation.Backoff
import org.springframework.retry.annotation.Retryable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class CommentService(
    private val commentRepository: CommentRepository,
    private val replyRepository: ReplyRepository,
    private val postRepository: PostRepository,
    private val validator: CommentReplyValidator,
    private val communityRepository: CommunityRepository,
    private val eventPublisher: ApplicationEventPublisher,
    private val userBlockRepository: UserBlockRepository,
    private val anonymousRepository: AnonymousRepository,

    ) {
    @Retryable(
        ObjectOptimisticLockingFailureException::class,
        maxAttempts = 3,
        backoff = Backoff(delay = 500),
    )
    fun create(userId: Long, request: CreateCommentRequest): CommentResponse {
        val post = postRepository.findByIdOrThrow(request.postId)
        val community = communityRepository.findByIdOrThrow(post.communityId)
        validator.validate(userId, community.departmentId)
        val comment = commentRepository.save(request.toEntity(userId))

        if (request.isAnonymous && !anonymousRepository.existsByUserIdAndPostId(userId, post.id)) {
            anonymousRepository.save(request.toAnonymousEntity(userId, post.id))
        }

        post.increaseCommentReplyCount()

        if (post.isEligibleForSSE(userId)) {
            val event = NotificationEvent.commentToPostUser(post, comment, community)
            eventPublisher.publishEvent(event)
        }
        return CommentResponse(comment)
    }

    fun update(userId: Long, request: UpdateCommentRequest) {
        val comment = commentRepository.findByIdAndUserId(request.commentId, userId)
            ?: throw CommentException(CommentExceptionType.NOT_FOUND_COMMENT)

        comment.changeContent(request.content)
    }

    @Retryable(
        ObjectOptimisticLockingFailureException::class,
        maxAttempts = 3,
        backoff = Backoff(delay = 500),
    )
    fun delete(userId: Long, request: DeleteCommentRequest) {
        val comment = commentRepository.findByIdAndUserId(request.commentId, userId)
            ?: throw CommentException(CommentExceptionType.NOT_FOUND_COMMENT)
        if (comment.isDeleted()) throw CommentException(CommentExceptionType.DELETED_COMMENT)
        commentRepository.delete(comment)

        val post = postRepository.findByIdOrThrow(comment.postId)
        post.decreaseCommentReplyCount()
    }

    fun like(userId: Long, request: LikeCommentRequest) {
        val comment = commentRepository.getByIdOrThrow(request.commentId)
        val post = postRepository.findByIdOrThrow(comment.postId)
        val community = communityRepository.findByIdOrThrow(post.communityId)

        validator.validate(userId, community.departmentId)
        comment.like(userId)
    }

    @Transactional(readOnly = true)
    fun findAllByPostId(userId: Long, request: CommentScrollPageRequest): CommentsResponse {
        val comments = commentRepository.findCommentWithUserByPostId(request)
        val blockedUserIds =
            userBlockRepository.findByBlockerUserId(userId).associateBy { it.blockedUserId }
        val anonymousList = anonymousRepository.findByPostId(request.postId)
        val post = postRepository.findByIdOrThrow(request.postId)

        val commentIds = comments.map { it.id }

        comments.forEach {
            it.isLiked = it.likeCount.findUserById(userId)
            updateUserInfo(it, blockedUserIds, anonymousList, post)
        }

        val replies = replyRepository.findRepliesWithUserByCommentIdIn(commentIds)
            .onEach {
                updateUserInfo(it, blockedUserIds, anonymousList, post)
            }.groupBy { it.commentId }

        val data = comments.map {
            CommentReplyWithUserResponse(
                it,
                replies = replies[it.id] ?: emptyList(),
            )
        }
        return CommentsResponse.of(data, request.size)
    }

    private fun updateUserInfo(
        it: CommentReplyResponse,
        blockedUserIds: Map<Long, UserBlock>,
        anonymousList: List<Anonymous>,
        post: Post,
    ) {
        it.isBlockedUser = blockedUserIds.contains(it.userId)
        val index = anonymousList.indexOfFirst { anon -> anon.userId == it.userId }
        val isOwner = it.userId == post.userId
        it.userInformation.nickname = determineNickname(isOwner, it.isAnonymous, it.userInformation.nickname, index)
    }

    private fun determineNickname(
        isOwner: Boolean,
        isAnonymous: Boolean,
        nickname: String,
        index: Int,
    ): String {
        return when {
            isAnonymous && index != -1 && isOwner -> "익명(글쓴이)"
            index != -1 && isAnonymous -> "익명" + (index + 1)
            else -> nickname
        }
    }
}
