package com.dclass.backend.application.dto

import com.dclass.backend.domain.reply.Reply
import com.dclass.backend.domain.reply.ReplyLikes
import com.dclass.backend.domain.user.User
import com.dclass.backend.domain.user.UserInformation
import io.swagger.v3.oas.annotations.media.Schema
import jakarta.validation.constraints.NotNull
import java.time.LocalDateTime

data class ReplyRequest(

    @Schema(
        description = "대댓글의 내용",
        example = "대댓글 내용",
    )
    val content: String,
)

data class CreateReplyRequest(

    @Schema(
        description = "댓글의 고유 식별자",
        example = "1",
    )
    @field:NotNull
    val commentId: Long,

    @Schema(
        description = "대댓글의 내용",
        example = "대댓글 내용",
    )
    @field:NotNull
    val content: String,

    @Schema(
        description = "익명 여부",
        example = "false",
    )
    val isAnonymous: Boolean = false,
) {
    fun toEntity(userId: Long): Reply {
        return Reply(userId, commentId, content, isAnonymous)
    }
}

data class UpdateReplyRequest(
    @Schema(
        description = "대댓글의 고유 식별자",
        example = "1",
    )
    val replyId: Long,

    @Schema(
        description = "대댓글의 내용",
        example = "대댓글 내용",
    )
    @field:NotNull
    val content: String,
)

data class DeleteReplyRequest(
    @Schema(
        description = "대댓글의 고유 식별자",
        example = "1",
    )
    val replyId: Long,
)

data class LikeReplyRequest(
    @Schema(
        description = "대댓글의 고유 식별자",
        example = "1",
    )
    val replyId: Long,
)

data class ReplyResponse(
    @Schema(
        description = "댓글의 고유 식별자",
        example = "1",
    )
    val id: Long,

    @Schema(
        description = "댓글을 작성한 유저의 고유 식별자",
        example = "1",
    )
    val userId: Long,

    @Schema(
        description = "대댓글이 달린 댓글의 고유 식별자",
        example = "1",
    )
    val commentId: Long,

    @Schema(
        description = "대댓글의 내용",
        example = "대댓글 내용",
    )
    val content: String,

    @Schema(
        description = "익명 여부",
        example = "false",
    )
    val isAnonymous: Boolean,

    @Schema(
        description = "대댓글의 좋아요 수",
        example = "0",
    )
    val likeCount: ReplyLikes,

    @Schema(
        description = "대댓글이 작성된 시각",
        example = "2021-08-01T00:00:00",
    )
    val createdAt: LocalDateTime,
) {
    constructor(reply: Reply) : this(
        id = reply.id,
        userId = reply.userId,
        commentId = reply.commentId,
        content = reply.content,
        isAnonymous = reply.isAnonymous,
        likeCount = reply.replyLikes,
        createdAt = reply.createdDateTime,
    )
}

data class ReplyWithUserResponse(
    @Schema(
        description = "대댓글의 고유 식별자",
        example = "1",
    )
    val id: Long,

    @Schema(
        description = "대댓글을 작성한 유저의 고유 식별자",
        example = "1",
    )
    val userId: Long,

    @Schema(
        description = "대댓글을 작성한 유저의 정보",
    )
    val userInformation: UserInformation,

    @Schema(
        description = "대댓글이 달린 댓글의 고유 식별자",
        example = "1",
    )
    val commentId: Long,

    @Schema(
        description = "대댓글의 내용",
        example = "대댓글 내용",
    )
    val content: String,

    @Schema(
        description = "익명 여부",
        example = "false",
    )
    val isAnonymous: Boolean,

    @Schema(
        description = "대댓글의 좋아요 수",
        example = "0",
    )
    val likeCount: ReplyLikes,

    @Schema(
        description = "차단한 사용자 여부",
        example = "false",
    )
    var isBlockedUser: Boolean = false,

    @Schema(
        description = "대댓글이 작성된 시각",
        example = "2021-08-01T00:00:00",
    )
    val createdAt: LocalDateTime,
) {
    constructor(reply: Reply, user: User) : this(
        id = reply.id,
        userId = reply.userId,
        userInformation = UserInformation(user.name, user.email, if(reply.isAnonymous) "익명" else user.nickname),
        commentId = reply.commentId,
        content = reply.content,
        isAnonymous = reply.isAnonymous,
        likeCount = reply.replyLikes,
        createdAt = reply.createdDateTime,
    )
}

data class ReplyValidatorDto(
    val postId: Long,
    val postUserId: Long,
    val commentUserId: Long,
    val communityTitle: String,
)
