package com.dclass.backend.application.dto

import com.dclass.backend.domain.comment.Comment
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