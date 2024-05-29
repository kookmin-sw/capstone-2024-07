package com.dclass.backend.domain.notification

import com.dclass.backend.domain.comment.Comment
import com.dclass.backend.domain.community.Community
import com.dclass.backend.domain.notification.NotificationType.COMMENT
import com.dclass.backend.domain.notification.NotificationType.REPLY
import com.dclass.backend.domain.post.Post
import com.dclass.backend.domain.reply.Reply

data class NotificationEvent(
    val userId: Long,
    val postId: Long,
    val commentId: Long,
    val replyId: Long?,
    val content: String,
    val community: String,
    val type: NotificationType,
) {
    companion object {
        fun commentToPostUser(post: Post, comment: Comment, community: Community) =
            NotificationEvent(
                post.userId,
                post.id,
                comment.id,
                null,
                comment.content,
                community.title,
                COMMENT,
            )

        fun replyToPostUser(post: Post, comment: Comment, reply: Reply, community: Community) =
            NotificationEvent(
                post.userId,
                post.id,
                comment.id,
                reply.id,
                reply.content,
                community.title,
                REPLY,
            )

        fun replyToCommentUser(post: Post, comment: Comment, reply: Reply, community: Community) =
            NotificationEvent(
                comment.userId,
                post.id,
                comment.id,
                reply.id,
                reply.content,
                community.title,
                REPLY,
            )
    }
}
