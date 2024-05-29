package com.dclass.support.fixtures

import com.dclass.backend.domain.comment.Comment

fun comment(
    postId: Long = 1L,
    userId: Long = 1L,
    content: String = "comment content",
): Comment {
    return Comment(
        postId = postId,
        userId = userId,
        content = content,
    )
}
