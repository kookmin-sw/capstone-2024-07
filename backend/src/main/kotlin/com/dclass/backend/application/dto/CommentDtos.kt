package com.dclass.backend.application.dto

import com.dclass.backend.domain.comment.Comment
import com.dclass.backend.domain.comment.CommentLikes
import com.dclass.backend.domain.user.User
import com.dclass.backend.domain.user.UserInformation
import io.swagger.v3.oas.annotations.media.Schema
import jakarta.validation.constraints.NotNull
import java.time.LocalDateTime

data class CommentRequest(
    @Schema(
        description = "댓글의 내용",
        example = "댓글 내용"
    )
    @field:NotNull
    val content: String,
)

data class CreateCommentRequest(
    @Schema(
        description = "게시글의 고유 식별자",
        example = "1"
    )
    val postId: Long,

    @Schema(
        description = "댓글의 내용",
        example = "댓글 내용"
    )
    @field:NotNull
    val content: String,
) {
    fun toEntity(userId: Long): Comment {
        return Comment(userId, postId, content)
    }
}

data class UpdateCommentRequest(
    @Schema(
        description = "댓글의 고유 식별자",
        example = "1"
    )
    val commentId: Long,

    @Schema(
        description = "댓글의 내용",
        example = "댓글 내용"
    )
    @field:NotNull
    val content: String,
)

data class DeleteCommentRequest(
    @Schema(
        description = "댓글의 고유 식별자",
        example = "1"
    )
    val commentId: Long,
)

data class LikeCommentRequest(
    @Schema(
        description = "댓글의 고유 식별자",
        example = "1"
    )
    val commentId: Long,
)


data class CommentResponse(
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
        description = "댓글이 달린 게시글의 고유 식별자",
        example = "1"
    )
    val postId: Long,

    @Schema(
        description = "댓글의 내용",
        example = "댓글 내용"
    )
    val content: String,

    @Schema(
        description = "댓글이 작성된 시각",
        example = "2021-08-01T00:00:00"
    )
    val createdDateTime: LocalDateTime,

    @Schema(
        description = "댓글이 수정된 시각",
        example = "2021-08-01T00:00:00"
    )
    val modifiedDateTime: LocalDateTime,
) {
    constructor(comment: Comment) : this(
        comment.id,
        comment.userId,
        comment.postId,
        comment.content,
        comment.createdDateTime,
        comment.modifiedDateTime
    )
}


data class CommentWithUserResponse(
    @Schema(
        description = "댓글의 고유 식별자",
        example = "1"
    )
    val id: Long,

    @Schema(
        description = "댓글을 작성한 유저의 정보",
        example = "1"
    )
    val userInformation: UserInformation,

    @Schema(
        description = "댓글이 달린 게시글의 고유 식별자",
        example = "1"
    )
    val postId: Long,

    @Schema(
        description = "댓글의 내용",
        example = "댓글 내용"
    )
    val content: String,

    @Schema(
        description = "댓글의 좋아요 수",
        example = "1"
    )
    val likeCount: CommentLikes,

    @Schema(
        description = "댓글의 좋아요 여부",
        example = "true"
    )
    val isLiked: Boolean,

    @Schema(
        description = "댓글이 작성된 시각",
        example = "2021-08-01T00:00:00"
    )
    val createdAt: LocalDateTime,
) {
    constructor(comment: Comment, user: User) : this(
        id = comment.id,
        userInformation = UserInformation(user.name, user.email, user.nickname),
        postId = comment.postId,
        content = comment.content,
        likeCount = comment.commentLikes,
        isLiked = false,
        createdAt = comment.createdDateTime
    )
}

data class CommentReplyWithUserResponse(
    @Schema(
        description = "댓글의 고유 식별자",
        example = "1"
    )
    val id: Long,

    @Schema(
        description = "댓글을 작성한 유저의 정보",
        example = "1"
    )
    val userInformation: UserInformation,

    @Schema(
        description = "댓글이 달린 게시글의 고유 식별자",
        example = "1"
    )
    val postId: Long,

    @Schema(
        description = "댓글의 내용",
        example = "댓글 내용"
    )
    val content: String,

    @Schema(
        description = "댓글의 좋아요 수",
        example = """
        {
            "likes": [1, 2],
            "count": 2
        }
        """
    )
    val likeCount: CommentLikes,


    @Schema(
        description = "댓글의 좋아요 여부",
        example = "true"
    )
    val isLiked: Boolean,

    @Schema(
        description = "댓글이 작성된 시각",
        example = "2021-08-01T00:00:00"
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
                "likeCount": {
                    "likes": [1, 2],
                    "count": 2
                },
                "createdAt": "2021-08-01T00:00:00"
            }
        ]
    """
    )
    val replies: List<ReplyWithUserResponse>

) {
    constructor(
        commentWithUserResponse: CommentWithUserResponse,
        replies: List<ReplyWithUserResponse>
    ) : this(
        id = commentWithUserResponse.id,
        userInformation = commentWithUserResponse.userInformation,
        postId = commentWithUserResponse.postId,
        content = commentWithUserResponse.content,
        likeCount = commentWithUserResponse.likeCount,
        isLiked = commentWithUserResponse.isLiked,
        createdAt = commentWithUserResponse.createdAt,
        replies = replies
    )
}