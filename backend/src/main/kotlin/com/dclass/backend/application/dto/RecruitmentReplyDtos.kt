package com.dclass.backend.application.dto

import com.dclass.backend.domain.recruitmentanonymous.RecruitmentAnonymous
import com.dclass.backend.domain.recruitmentreply.RecruitmentReply
import com.dclass.backend.domain.user.User
import com.dclass.backend.domain.user.UserInformation
import io.swagger.v3.oas.annotations.media.Schema
import java.time.LocalDateTime

data class CreateRecruitmentReplyRequest(
    @Schema(
        description = "댓글의 고유 식별자",
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
    val isAnonymous: Boolean = false,
) {
    fun toEntity(userId: Long): RecruitmentReply {
        return RecruitmentReply(userId, commentId, content, isAnonymous = isAnonymous)
    }

    fun toAnonymousEntity(userId: Long, postId: Long): RecruitmentAnonymous {
        return RecruitmentAnonymous(userId, postId)
    }
}

data class UpdateRecruitmentReplyRequest(
    @Schema(
        description = "대댓글의 고유 식별자",
        example = "1",
    )
    val replyId: Long,

    @Schema(
        description = "대댓글의 내용",
        example = "대댓글 내용",
    )
    val content: String,
)

data class DeleteRecruitmentReplyRequest(
    @Schema(
        description = "대댓글의 고유 식별자",
        example = "1",
    )
    val replyId: Long,
)

data class RecruitmentReplyResponse(
    @Schema(
        description = "대댓글의 고유 식별자",
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
        description = "대댓글이 작성된 시각",
        example = "2021-08-01T00:00:00",
    )
    val createdAt: LocalDateTime,
) {
    constructor(reply: RecruitmentReply) : this(
        reply.id,
        reply.userId,
        reply.recruitmentCommentId,
        reply.content,
        reply.isAnonymous,
        reply.createdDateTime,
    )
}

data class RecruitmentReplyWithUserResponse(
    @Schema(
        description = "대댓글의 고유 식별자",
        example = "1",
    )
    val id: Long,

    @Schema(
        description = "댓글을 작성한 유저의 고유 식별자",
        example = "1",
    )
    override val userId: Long,

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
    override var isAnonymous: Boolean,

    @Schema(
        description = "차단한 사용자 여부",
        example = "false",
    )
    override var isBlockedUser: Boolean = false,

    @Schema(
        description = "대댓글을 작성한 유저의 정보",
    )
    override val userInformation: UserInformation,

    @Schema(
        description = "대댓글이 작성된 시각",
        example = "2021-08-01T00:00:00",
    )
    val createdAt: LocalDateTime,
) : RecruitmentCommentReplyResponse {
    constructor(reply: RecruitmentReply, user: User) : this(
        id = reply.id,
        userId = reply.userId,
        commentId = reply.recruitmentCommentId,
        content = reply.content,
        isAnonymous = reply.isAnonymous,
        createdAt = reply.createdDateTime,
        userInformation = UserInformation(user.name, user.email, user.nickname),
    )
}
