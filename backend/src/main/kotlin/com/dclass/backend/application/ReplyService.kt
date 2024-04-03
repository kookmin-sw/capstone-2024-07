package com.dclass.backend.application

import com.dclass.backend.application.dto.*
import com.dclass.backend.domain.notification.NotificationCommentEvent
import com.dclass.backend.domain.notification.NotificationReplyEvent
import com.dclass.backend.domain.notification.NotificationType
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.getByIdOrThrow
import com.dclass.backend.domain.reply.ReplyRepository
import com.dclass.backend.domain.reply.getByIdAndUserIdOrThrow
import com.dclass.backend.domain.reply.getByIdOrThrow
import org.springframework.context.ApplicationEventPublisher
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class ReplyService(
    private val replyRepository: ReplyRepository,
    private val replyValidator: ReplyValidator,
    private val eventPublisher: ApplicationEventPublisher,
    private val postRepository: PostRepository
) {
    fun create(userId: Long, request: CreateReplyRequest): ReplyResponse {
        val dto = replyValidator.validateCreateReply(userId, request.commentId)
        val reply = replyRepository.save(request.toEntity(userId))
        if (userId != dto.postUserId) {
            eventPublisher.publishEvent(
                NotificationCommentEvent.of(dto, request.commentId, request.content, NotificationType.REPLY)
            )
        }
        if (userId != dto.commentUserId) {
            eventPublisher.publishEvent(
                NotificationReplyEvent.of(dto, request.commentId, reply.id, request.content, NotificationType.REPLY)
            )
        }
        return ReplyResponse(reply)

    }

    fun update(userId: Long, request: UpdateReplyRequest) {
        val reply = replyRepository.getByIdAndUserIdOrThrow(request.replyId, userId)
        reply.changeContent(request.content)
    }

    fun delete(userId: Long, request: DeleteReplyRequest) {
        val reply = replyRepository.getByIdAndUserIdOrThrow(request.replyId, userId)
        val comment = replyValidator.validateDeleteReply(userId, reply.commentId)
        val post = postRepository.getByIdOrThrow(comment.postId)
        post.increaseCommentReplyCount(-1)
        replyRepository.delete(reply)
    }

    fun like(userId: Long, request: LikeReplyRequest) {
        replyValidator.validateLikeReply(userId, request.replyId)
        val reply = replyRepository.getByIdOrThrow(request.replyId)
        reply.like(userId)
    }
}