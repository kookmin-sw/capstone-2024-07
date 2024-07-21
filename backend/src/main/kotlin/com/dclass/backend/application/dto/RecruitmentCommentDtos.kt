package com.dclass.backend.application.dto

import com.dclass.backend.domain.recruitmentcomment.RecruitmentComment
import com.dclass.backend.domain.user.User
import com.dclass.backend.domain.user.UserInformation
import io.swagger.v3.oas.annotations.media.Schema
import java.time.LocalDateTime

data class CreateRecruitmentCommentRequest(
    @Schema(
        description = "게시글의 고유 식별자",
        example = "1",
    )
    val recruitmentId: Long,

    @Schema(
        description = "댓글의 내용",
        example = "댓글 내용",
    )
    val content: String,

    // TODO : 익명 여부 추가
//    @Schema(
//        description = "익명 여부",
//        example = "false",
//    )
//    val isAnonymous: Boolean = false,
) {
    fun toEntity(userId: Long): RecruitmentComment {
        return RecruitmentComment(userId, recruitmentId, content)
    }
}

data class UpdateRecruitmentCommentRequest(
    @Schema(
        description = "댓글의 고유 식별자",
        example = "1",
    )
    val commentId: Long,

    @Schema(
        description = "댓글의 내용",
        example = "댓글 내용",
    )
    val content: String,
)

data class DeleteRecruitmentCommentRequest(
    @Schema(
        description = "댓글의 고유 식별자",
        example = "1",
    )
    val commentId: Long,
)

interface RecruitmentCommentReplyResponse{
    val userId: Long
//    var isBlockedUser: Boolean
    // TODO : 익명 여부 추가
//    val isAnonymous: Boolean
    val userInformation: UserInformation
}

data class RecruitmentCommentResponse(
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
        description = "게시글의 고유 식별자",
        example = "1",
    )
    val recruitmentId: Long,

    @Schema(
        description = "댓글의 내용",
        example = "댓글 내용",
    )
    val content: String,

    // TODO : 익명 여부 추가
//    @Schema(
//        description = "익명 여부",
//        example = "false",
//    )
//    val isAnonymous: Boolean = false,

    @Schema(
        description = "댓글이 작성된 시각",
        example = "2021-08-01T00:00:00",
    )
    val createdDateTime: LocalDateTime,

    @Schema(
        description = "댓글이 수정된 시각",
        example = "2021-08-01T00:00:00",
    )
    val modifiedDateTime: LocalDateTime,
) {
    constructor(comment: RecruitmentComment) : this(
        comment.id,
        comment.userId,
        comment.recruitmentId,
        comment.content,
//        comment.isAnonymous,
        comment.createdDateTime,
        comment.modifiedDateTime,
    )
}

data class RecruitmentCommentWithUserResponse(
    @Schema(
        description = "댓글의 고유 식별자",
        example = "1",
    )
    val id: Long,

    @Schema(
        description = "댓글을 작성한 유저의 고유 식별자",
        example = "1",
    )
    override val userId: Long,

    @Schema(
        description = "게시글의 고유 식별자",
        example = "1",
    )
    val recruitmentId: Long,

    @Schema(
        description = "댓글의 내용",
        example = "댓글 내용",
    )
    val content: String,

    @Schema(
        description = "댓글의 삭제 여부",
        example = "false",
    )
    val deleted: Boolean,

    // TODO : 익명 여부 추가
//    @Schema(
//        description = "익명 여부",
//        example = "false",
//    )
//    override val isAnonymous: Boolean = false,

    @Schema(
        description = "댓글이 작성된 시각",
        example = "2021-08-01T00:00:00",
    )
    val createdDateTime: LocalDateTime,

    @Schema(
        description = "댓글이 수정된 시각",
        example = "2021-08-01T00:00:00",
    )
    val modifiedDateTime: LocalDateTime,

    @Schema(
        description = "댓글을 작성한 유저의 정보",
    )
    override val userInformation: UserInformation,

//    @Schema(
//        description = "차단 여부",
//        example = "false",
//    )
//    override var isBlockedUser: Boolean,
) : RecruitmentCommentReplyResponse {
    constructor(comment: RecruitmentComment, user: User) : this(
        id = comment.id,
        userId = comment.userId,
        recruitmentId = comment.recruitmentId,
        content = comment.content.takeIf { !comment.isDeleted() } ?: "삭제된 댓글 입니다.",
        deleted = comment.isDeleted(),
        // TODO : 익명 여부 추가
//        isAnonymous = comment.isAnonymous,
        createdDateTime = comment.createdDateTime,
        modifiedDateTime = comment.modifiedDateTime,
//        isBlockedUser = false,
        userInformation = UserInformation(user.name, user.email, user.nickname),
    )
}

data class RecruitmentCommentReplyWithUserResponse(
    @Schema(
        description = "댓글의 고유 식별자",
        example = "1",
    )
    val id: Long,

    @Schema(
        description = "댓글을 작성한 유저의 정보",
        example = "1",
    )
    val userInformation: UserInformation,

    @Schema(
        description = "댓글을 작성한 유저의 고유 id",
        example = "1",
    )
    val userId: Long,

    @Schema(
        description = "댓글이 달린 게시글의 고유 식별자",
        example = "1",
    )
    val recruitmentId: Long,

    @Schema(
        description = "댓글의 내용",
        example = "댓글 내용",
    )
    val content: String,

    @Schema(
        description = "댓글의 삭제 여부",
        example = "false",
    )
    val deleted: Boolean,

//    @Schema(
//        description = "차단된 사용자 여부",
//        example = "true",
//    )
//    var isBlockedUser: Boolean,

    // TODO : 익명 여부 추가
//    @Schema(
//        description = "익명 여부",
//        example = "false",
//    )
//    val isAnonymous: Boolean = false,

    @Schema(
        description = "댓글이 작성된 시각",
        example = "2021-08-01T00:00:00",
    )
    val createdAt: LocalDateTime,

    @Schema(
        description = "댓글의 답글 목록",
        example = """
        [
            {
                "id": 1,
                "userId": 1,
                "userInformation": {
                    "name": "이름",
                    "email": "이메일",
                    "nickname": "닉네임"
                },
                "commentId": 1,
                "content": "대댓글 내용",
                "createdAt": "2021-08-01T00:00:00"
            }
        ]
    """,
    )
    val replies: List<RecruitmentReplyWithUserResponse>,
) {
    constructor(
        commentWithUserResponse: RecruitmentCommentWithUserResponse,
        replies: List<RecruitmentReplyWithUserResponse>,
    ) : this(
        id = commentWithUserResponse.id,
        userId = commentWithUserResponse.userId,
        userInformation = commentWithUserResponse.userInformation,
        recruitmentId = commentWithUserResponse.recruitmentId,
        content = commentWithUserResponse.content,
        deleted = commentWithUserResponse.deleted,
//        isBlockedUser = commentWithUserResponse.isBlockedUser,
        // TODO : 익명 여부 추가
//        isAnonymous = commentWithUserResponse.isAnonymous,
        createdAt = commentWithUserResponse.createdDateTime,
        replies = replies,
    )
}


data class RecruitmentCommentsResponse(
    @Schema(
        description = "댓글 목록",
        example = "['댓글 목록']",
    )
    val data: List<RecruitmentCommentReplyWithUserResponse>,

    @Schema(
        description = "댓글 목록의 메타데이터",
        example = "{'count': 10, 'hasMore': true}",
    )
    val meta: MetaData,
) {
    companion object{
        fun of(data: List<RecruitmentCommentReplyWithUserResponse>, limit: Int) : RecruitmentCommentsResponse {
            return RecruitmentCommentsResponse(data, MetaData(data.size, data.size == limit))
        }
    }
}

data class RecruitmentCommentScrollRequest(
    @Schema(
        description = "게시글의 고유 식별자",
        example = "1",
    )
    val recruitmentId: Long,

    @Schema(
        description = "댓글의 고유 식별자",
        example = "1",
    )
    val lastCommentId: Long? = null,

    @Schema(
        description = "댓글의 개수",
        example = "20",
    )
    val size: Int = 20,
)
