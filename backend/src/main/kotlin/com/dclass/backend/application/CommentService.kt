package com.dclass.backend.application

import com.dclass.backend.application.dto.*
import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.comment.getByIdOrThrow
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.community.findByIdOrThrow
import com.dclass.backend.domain.notification.NotificationEvent
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.findByIdOrThrow
import com.dclass.backend.domain.reply.ReplyRepository
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
    private val commentValidator: CommentValidator,
    private val communityRepository: CommunityRepository,
    private val eventPublisher: ApplicationEventPublisher,
    private val userBlockRepository: UserBlockRepository,
) {
    @Retryable(
        ObjectOptimisticLockingFailureException::class,
        maxAttempts = 3,
        backoff = Backoff(delay = 500),
    )
    fun create(userId: Long, request: CreateCommentRequest): CommentResponse {
        val post = postRepository.findByIdOrThrow(request.postId)
        val community = communityRepository.findByIdOrThrow(post.communityId)
        commentValidator.validate(userId, community)
        val comment = commentRepository.save(request.toEntity(userId))

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

        commentValidator.validate(userId, community)
        comment.like(userId)
    }

    @Transactional(readOnly = true)
    fun findAllByPostId(userId: Long, request: CommentScrollPageRequest): CommentsResponse {
        val comments = commentRepository.findCommentWithUserByPostId(request)
        val blockedUserIds =
            userBlockRepository.findByBlockerUserId(userId).associateBy { it.blockedUserId }

        comments.forEach {
            it.isLiked = it.likeCount.findUserById(userId)
            it.isBlockedUser = blockedUserIds.contains(it.userId)
        }

        val commentIds = comments.map { it.id }

        val replies = replyRepository.findRepliesWithUserByCommentIdIn(commentIds)
            .onEach { it.isBlockedUser = blockedUserIds.contains(it.userId) }
            .groupBy { it.commentId }

        val data = comments.map {
            CommentReplyWithUserResponse(
                it,
                replies = replies[it.id] ?: emptyList(),
            )
        }
        return CommentsResponse.of(data, request.size)
    }
}
