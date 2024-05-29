package com.dclass.backend.application.dto

import com.dclass.backend.domain.notification.Notification
import com.dclass.backend.domain.notification.NotificationType
import io.swagger.v3.oas.annotations.media.Schema
import java.time.LocalDateTime

abstract class NotificationRequest {
    abstract val userId: Long
    abstract fun toEntity(): Notification
    abstract fun createResponse(id: Long, createdAt: LocalDateTime): NotificationResponse
}

data class NotificationCommentRequest(
    override val userId: Long,
    val postId: Long,
    val commentId: Long,
    val content: String,
    val communityTitle: String,
    val type: NotificationType,
) : NotificationRequest() {
    override fun toEntity(): Notification {
        return Notification(userId, postId, content, type = type)
    }

    override fun createResponse(id: Long, createdAt: LocalDateTime): NotificationResponse {
        return NotificationCommentResponse(
            id = id,
            userId = userId,
            postId = postId,
            commentId = commentId,
            content = content,
            type = type,
            createdAt = createdAt,
            isRead = false,
            communityTitle = communityTitle,
        )
    }
}

data class NotificationReplyRequest(
    override val userId: Long,
    val postId: Long,
    val commentId: Long,
    val replyId: Long,
    val content: String,
    val communityTitle: String,
    val type: NotificationType,
) : NotificationRequest() {
    override fun toEntity(): Notification {
        return Notification(userId, postId, content, type = type)
    }

    override fun createResponse(id: Long, createdAt: LocalDateTime): NotificationResponse {
        return NotificationReplyResponse(
            id = id,
            userId = userId,
            postId = postId,
            commentId = commentId,
            replyId = replyId,
            content = content,
            type = type,
            createdAt = createdAt,
            isRead = false,
            communityTitle = communityTitle,
        )
    }
}

abstract class NotificationResponse

data class NotificationCommentResponse(
    @Schema(
        description = "알림의 고유 식별자",
        example = "1",
    )
    val id: Long,

    @Schema(
        description = "알림을 받은 유저의 고유 식별자",
        example = "1",
    )
    val userId: Long,

    @Schema(
        description = "알림이 발생한 게시글의 고유 식별자",
        example = "1",
    )
    val postId: Long,

    @Schema(
        description = "알림이 발생한 댓글의 고유 식별자",
        example = "1",
    )
    val commentId: Long,

    @Schema(
        description = "알림의 내용",
        example = "댓글 내용",
    )
    val content: String,

    @Schema(
        description = "알림의 타입",
        example = "COMMENT",
    )
    val type: NotificationType,

    @Schema(
        description = "알림이 생성된 시각",
        example = "2021-08-01T00:00:00",
    )
    val createdAt: LocalDateTime,

    @Schema(
        description = "알림을 읽었는지 여부",
        example = "false",
    )
    val isRead: Boolean,

    @Schema(
        description = "알림이 발생한 커뮤니티의 타이틀",
        example = "자유게시판",
    )
    val communityTitle: String,
) : NotificationResponse()

data class NotificationReplyResponse(
    @Schema(
        description = "알림의 고유 식별자",
        example = "1",
    )
    val id: Long,

    @Schema(
        description = "알림을 받은 유저의 고유 식별자",
        example = "1",
    )
    val userId: Long,

    @Schema(
        description = "알림이 발생한 게시글의 고유 식별자",
        example = "1",
    )
    val postId: Long,

    @Schema(
        description = "알림이 발생한 댓글의 고유 식별자",
        example = "1",
    )
    val commentId: Long,

    @Schema(
        description = "알림이 발생한 답글의 고유 식별자",
        example = "1",
    )
    val replyId: Long,

    @Schema(
        description = "알림의 내용",
        example = "답글 내용",
    )
    val content: String,

    @Schema(
        description = "알림의 타입",
        example = "REPLY",
    )
    val type: NotificationType,

    @Schema(
        description = "알림이 생성된 시각",
        example = "2021-08-01T00:00:00",
    )
    val createdAt: LocalDateTime,

    @Schema(
        description = "알림을 읽었는지 여부",
        example = "false",
    )
    val isRead: Boolean,

    @Schema(
        description = "알림이 발생한 커뮤니티의 타이틀",
        example = "자유게시판",
    )
    val communityTitle: String,
) : NotificationResponse()
