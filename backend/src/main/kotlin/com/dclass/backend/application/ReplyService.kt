package com.dclass.backend.application

import com.dclass.backend.application.dto.CreateReplyRequest
import com.dclass.backend.application.dto.DeleteReplyRequest
import com.dclass.backend.application.dto.LikeReplyRequest
import com.dclass.backend.application.dto.ReplyResponse
import com.dclass.backend.application.dto.UpdateReplyRequest
import com.dclass.backend.domain.anonymous.AnonymousRepository
import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.comment.getByIdOrThrow
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.community.findByIdOrThrow
import com.dclass.backend.domain.notification.NotificationEvent
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.findByIdOrThrow
import com.dclass.backend.domain.reply.ReplyRepository
import com.dclass.backend.domain.reply.getByIdAndUserIdOrThrow
import com.dclass.backend.domain.reply.getByIdOrThrow
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
class ReplyService(
    private val replyRepository: ReplyRepository,
    private val validator: CommentReplyValidator,
    private val eventPublisher: ApplicationEventPublisher,
    private val communityRepository: CommunityRepository,
    private val commentRepository: CommentRepository,
    private val postRepository: PostRepository,
    private val anonymousRepository: AnonymousRepository,
) {
    @Retryable(
        ObjectOptimisticLockingFailureException::class,
        maxAttempts = 3,
        backoff = Backoff(delay = 500),
    )
    fun create(userId: Long, request: CreateReplyRequest): ReplyResponse {
        val comment = commentRepository.getByIdOrThrow(request.commentId)

        if (comment.isDeleted()) {
            throw CommentException(CommentExceptionType.DELETED_COMMENT)
        }

        val post = postRepository.findByIdOrThrow(comment.postId)
        val community = communityRepository.findByIdOrThrow(post.communityId)

        validator.validate(userId, community.departmentId)

        val reply = replyRepository.save(request.toEntity(userId))

        if (request.isAnonymous && !anonymousRepository.existsByUserIdAndPostId(userId, post.id)) {
            anonymousRepository.save(request.toAnonymousEntity(userId, post.id))
        }

        if (post.isEligibleForSSE(userId)) {
            val event = NotificationEvent.replyToPostUser(post, comment, reply, community)
            eventPublisher.publishEvent(event)
        }
        if (comment.isEligibleForSSE(userId)) {
            val event = NotificationEvent.replyToCommentUser(post, comment, reply, community)
            eventPublisher.publishEvent(event)
        }

        comment.increaseReplyCount()
        post.increaseCommentReplyCount()

        return ReplyResponse(reply)
    }

    fun update(userId: Long, request: UpdateReplyRequest) {
        val reply = replyRepository.getByIdAndUserIdOrThrow(request.replyId, userId)
        reply.changeContent(request.content)
    }

    @Retryable(
        ObjectOptimisticLockingFailureException::class,
        maxAttempts = 3,
        backoff = Backoff(delay = 500),
    )
    fun delete(userId: Long, request: DeleteReplyRequest) {
        val reply = replyRepository.getByIdAndUserIdOrThrow(request.replyId, userId)

        val comment = commentRepository.getByIdOrThrow(reply.commentId)
        val post = postRepository.findByIdOrThrow(comment.postId)
        post.decreaseCommentReplyCount()
        comment.decreaseReplyCount()

        replyRepository.delete(reply)
    }

    fun like(userId: Long, request: LikeReplyRequest) {
        val reply = replyRepository.getByIdOrThrow(request.replyId)
        val comment = commentRepository.getByIdOrThrow(reply.commentId)
        val post = postRepository.findByIdOrThrow(comment.postId)
        val community = communityRepository.findByIdOrThrow(post.communityId)

        validator.validate(userId, community.departmentId)
        reply.like(userId)
    }
}
