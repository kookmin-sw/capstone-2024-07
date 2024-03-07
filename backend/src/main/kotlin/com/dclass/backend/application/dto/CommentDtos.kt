package com.dclass.backend.application.dto

import com.dclass.backend.domain.comment.Comment
import com.dclass.backend.domain.comment.CommentLikes
import com.dclass.backend.domain.user.User
import com.dclass.backend.domain.user.UserInformation
import jakarta.validation.constraints.NotNull
import java.time.LocalDateTime


data class CreateCommentRequest(
    val postId: Long,

    @field:NotNull
    val content: String,
)

data class UpdateCommentRequest(
    val commentId: Long,
    val content: String,
)

data class DeleteCommentRequest(
    val commentId: Long,
)

data class CommentResponse(
    val id: Long,
    val userId: Long,
    val postId: Long,
    val content: String,
    val createdDateTime: LocalDateTime,
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
    val id: Long,
    val userInformation: UserInformation,
    val postId: Long,
    val content: String,
    val likeCount: CommentLikes,
    val isLiked: Boolean,
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
    val id: Long,
    val userInformation: UserInformation,
    val postId: Long,
    val content: String,
    val likeCount: CommentLikes,
    val isLiked: Boolean,
    val createdAt: LocalDateTime,
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