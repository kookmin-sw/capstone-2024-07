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
    private val postRepository: PostRepository,
    private val eventPublisher: ApplicationEventPublisher
) {
    fun create(userId: Long, request: CreateReplyRequest): ReplyResponse {
        val replyValidatorDto = replyValidator.validateCreateReply(userId, request.commentId)
        val postUserId = postRepository.getByIdOrThrow(replyValidatorDto.postId).userId
        val reply = replyRepository.save(request.toEntity(userId))
        eventPublisher.publishEvent(
            NotificationCommentEvent(
                postUserId,
                replyValidatorDto.postId,
                request.commentId,
                request.content,
                replyValidatorDto.communityTitle,
                NotificationType.COMMENT
            )
        )
        eventPublisher.publishEvent(
            NotificationReplyEvent(
                replyValidatorDto.commentUserId,
                replyValidatorDto.postId,
                request.commentId,
                reply.id,
                request.content,
                replyValidatorDto.communityTitle,
                NotificationType.REPLY
            )
        )
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