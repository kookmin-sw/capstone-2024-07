package com.dclass.support.fixtures

import com.dclass.backend.domain.comment.Comment
import com.dclass.backend.domain.comment.CommentLikes
import jakarta.persistence.Column
import java.time.LocalDateTime

fun createComment(
    userId: Long = 1L,
    postId: Long = 1L,
    content: String = "content",
    commentLikes: CommentLikes = CommentLikes(),
    createdDateTime: LocalDateTime = LocalDateTime.now(),
    modifiedDateTime: LocalDateTime = LocalDateTime.now(),
): Comment {
    return Comment(
        userId = userId,
        postId = postId,
        content = content,
        commentLikes = commentLikes,
        createdDateTime = createdDateTime,
        modifiedDateTime = modifiedDateTime
    )
}