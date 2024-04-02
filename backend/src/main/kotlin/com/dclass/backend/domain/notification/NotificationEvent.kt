package com.dclass.backend.domain.notification

data class NotificationCommentEvent(
    val userId: Long,
    val postId: Long,
    val commentId: Long,
    val content: String,
    val community: String,
    val type: NotificationType,
)

data class NotificationReplyEvent(
    val userId: Long,
    val postId: Long,
    val commentId: Long,
    val replyId: Long,
    val content: String,
    val community: String,
    val type: NotificationType,
)