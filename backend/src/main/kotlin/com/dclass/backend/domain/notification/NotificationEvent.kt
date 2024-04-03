package com.dclass.backend.domain.notification

import com.dclass.backend.application.dto.CommentValidatorDto
import com.dclass.backend.application.dto.ReplyValidatorDto

data class NotificationCommentEvent(
    val userId: Long,
    val postId: Long,
    val commentId: Long,
    val content: String,
    val community: String,
    val type: NotificationType,
) {
    companion object {
        fun of(dto: CommentValidatorDto, commentId: Long, content: String, type: NotificationType) =
            NotificationCommentEvent(
                dto.post.userId,
                dto.post.id,
                commentId,
                content,
                dto.communityTitle,
                type
            )

        fun of(dto: ReplyValidatorDto, commentId: Long, content: String, type: NotificationType) =
            NotificationCommentEvent(
                dto.postUserId,
                dto.postId,
                commentId,
                content,
                dto.communityTitle,
                type
            )
    }
}

data class NotificationReplyEvent(
    val userId: Long,
    val postId: Long,
    val commentId: Long,
    val replyId: Long,
    val content: String,
    val community: String,
    val type: NotificationType,
) {
    companion object {
        fun of(dto: ReplyValidatorDto, commentId: Long, replyId: Long, content: String, type: NotificationType) =
            NotificationReplyEvent(
                dto.commentUserId,
                dto.postId,
                commentId,
                replyId,
                content,
                dto.communityTitle,
                type
            )
    }
}