package com.dclass.backend.application.dto

import com.dclass.backend.domain.reply.Reply
import com.dclass.backend.domain.reply.ReplyLikes
import com.dclass.backend.domain.user.User
import com.dclass.backend.domain.user.UserInformation
import java.time.LocalDateTime

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