package com.dclass.backend.application.dto

import com.dclass.backend.domain.post.Post
import com.dclass.backend.domain.post.PostCount
import com.dclass.backend.domain.user.User
import java.time.LocalDateTime


data class PostScrollPageRequest(
    val lastId: Long?,
    val communityId: Long,
    val size: Int,
)

/**
 * modifiedDateTime은 필요할까?
 */
data class PostResponse(
    val id: Long,
    val userId: Long,
    val userNickname: String,
    val universityName: String,
    val communityId: Long,
    val communityTitle: String,
    val postTitle: String,
    val postContent: String,
    val images: List<String>,
    val count: PostCount,
    val isQuestion: Boolean,
    val createdDateTime: LocalDateTime,
) {
    constructor(
        post: Post,
        user: User,
        communityTitle: String
    ) : this(
        post.id,
        post.userId,
        user.nickname,
        user.universityName,
        post.communityId,
        communityTitle,
        post.title,
        post.content,
        post.images.map { it.imageKey },
        post.postCount,
        post.isQuestion,
        post.createdDateTime
    )
}