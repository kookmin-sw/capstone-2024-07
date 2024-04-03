package com.dclass.backend.application

import com.dclass.backend.application.dto.*
import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.comment.getByIdOrThrow
import com.dclass.backend.domain.notification.NotificationCommentEvent
import com.dclass.backend.domain.notification.NotificationType
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.getByIdOrThrow
import com.dclass.backend.domain.reply.ReplyRepository
import com.dclass.backend.exception.comment.CommentException
import com.dclass.backend.exception.comment.CommentExceptionType
import org.springframework.context.ApplicationEventPublisher
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class CommentService(
    private val commentRepository: CommentRepository,
    private val replyRepository: ReplyRepository,
    private val commentValidator: CommentValidator,
    private val eventPublisher: ApplicationEventPublisher,
    private val postRepository: PostRepository,
) {
    fun create(userId: Long, request: CreateCommentRequest): CommentResponse {
        val dto = commentValidator.validateCreateComment(userId, request.postId)
        dto.post.increaseCommentReplyCount(1)
        val comment = commentRepository.save(request.toEntity(userId))
        if (userId != dto.post.userId) {
            eventPublisher.publishEvent(
                NotificationCommentEvent.of(dto, comment.id, request.content, NotificationType.COMMENT)
            )
        }
        return CommentResponse(comment)
    }

    fun update(userId: Long, request: UpdateCommentRequest) {
        val comment = commentRepository.findByIdAndUserId(request.commentId, userId)
            ?: throw CommentException(CommentExceptionType.NOT_FOUND_COMMENT)

        comment.changeContent(request.content)
    }

    fun delete(userId: Long, request: DeleteCommentRequest) {
        val comment = commentRepository.findByIdAndUserId(request.commentId, userId)
            ?: throw CommentException(CommentExceptionType.NOT_FOUND_COMMENT)
        val post = postRepository.getByIdOrThrow(comment.postId)
        commentRepository.delete(comment)
        post.increaseCommentReplyCount(-1)
    }

    fun like(userId: Long, request: LikeCommentRequest) {
        commentValidator.validateLikeComment(userId, request.commentId)
        val comment = commentRepository.getByIdOrThrow(request.commentId)
        comment.like(userId)
    }

    @Transactional(readOnly = true)
    fun findAllByPostId(postId: Long): List<CommentReplyWithUserResponse> {
        val comments = commentRepository.findCommentWithUserByPostId(postId)

        val commentIds = comments.map { it.id }

        val replies = replyRepository.findRepliesWithUserByCommentIdIn(commentIds)
            .groupBy { it.commentId }

        return comments.map {
            CommentReplyWithUserResponse(
                it,
                replies = replies[it.id] ?: emptyList()
            )
        }
    }
}
