package com.dclass.backend.application.dto

import com.dclass.backend.domain.reply.Reply
import com.dclass.backend.domain.reply.ReplyLikes
import com.dclass.backend.domain.user.User
import com.dclass.backend.domain.user.UserInformation
import io.swagger.v3.oas.annotations.media.Schema
import jakarta.validation.constraints.NotNull
import java.time.LocalDateTime

data class ReplyRequest(
    val content: String,
)

data class CreateReplyRequest(
    @field:NotNull
    val commentId: Long,

    @field:NotNull
    val content: String,
)

data class UpdateReplyRequest(
    val replyId: Long,

    @field:NotNull
    val content: String,
)

data class DeleteReplyRequest(
    val replyId: Long,
)

data class LikeReplyRequest(
    val replyId: Long,
)

data class ReplyResponse(
    @Schema(
        description = "댓글의 고유 식별자",
        example = "1"
    )
    val id: Long,

    @Schema(
        description = "댓글을 작성한 유저의 고유 식별자",
        example = "1"
    )
    val userId: Long,

    @Schema(
        description = "대댓글이 달린 댓글의 고유 식별자",
        example = "1"
    )
    val commentId: Long,

    @Schema(
        description = "대댓글의 내용",
        example = "대댓글 내용"
    )
    val content: String,

    @Schema(
        description = "대댓글의 좋아요 수",
        example = "0"
    )
    val likeCount: ReplyLikes,

    @Schema(
        description = "대댓글이 작성된 시각",
        example = "2021-08-01T00:00:00"
    )
    val createdAt: LocalDateTime,
) {
    constructor(reply: Reply) : this(
        id = reply.id,
        userId = reply.userId,
        commentId = reply.commentId,
        content = reply.content,
        likeCount = reply.replyLikes,
        createdAt = reply.createdDateTime
    )
}

data class ReplyWithUserResponse(
    val id: Long,
    val userId: Long,
    val userInformation: UserInformation,
    val commentId: Long,
    val content: String,
    val likeCount: ReplyLikes,
    val createdAt: LocalDateTime,
) {
    constructor(reply: Reply, user: User) : this(
        id = reply.id,
        userId = reply.userId,
        userInformation = UserInformation(user.name, user.email, user.nickname),
        commentId = reply.commentId,
        content = reply.content,
        likeCount = reply.replyLikes,
        createdAt = reply.createdDateTime
    )
}