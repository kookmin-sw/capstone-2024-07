package com.dclass.support.fixtures

import com.dclass.backend.domain.reply.Reply

fun reply(
    userId: Long = 1L,
    commentId: Long = 1L,
    content: String = "reply content",
): Reply {
    return Reply(
        userId = userId,
        commentId = commentId,
        content = content,
    )
}
