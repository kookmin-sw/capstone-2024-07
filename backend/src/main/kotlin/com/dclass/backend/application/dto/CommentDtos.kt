package com.dclass.backend.application.dto

import com.dclass.backend.domain.comment.Comment
import com.dclass.backend.domain.user.User
import com.dclass.backend.domain.user.UserInformation
import java.time.LocalDateTime

data class CommentWithUserResponse(
    val id: Long,
    val userInformation: UserInformation,
    val postId: Long,
    val content: String,
    val likeCount: Int,
    val isLiked: Boolean,
    val createdAt: LocalDateTime,
) {
    constructor(comment: Comment, user: User) : this(
        id = comment.id,
        userInformation = UserInformation(user.name, user.email, user.nickname),
        postId = comment.postId,
        content = comment.content,
        likeCount = comment.likeCount,
        isLiked = false,
        createdAt = comment.createdDateTime
    )
}