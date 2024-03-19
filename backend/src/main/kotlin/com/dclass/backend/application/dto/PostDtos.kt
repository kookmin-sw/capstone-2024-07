package com.dclass.backend.application.dto

import com.dclass.backend.domain.community.CommunityType
import com.dclass.backend.domain.post.Post
import com.dclass.backend.domain.post.PostCount
import com.dclass.backend.domain.user.User
import com.dclass.support.domain.Image
import java.time.LocalDateTime


data class PostScrollPageRequest(
    val lastId: Long? = null,
    var communityTitle: String? = null,
    val size: Int,
    val isHot: Boolean = false,
) {
    init {
        communityTitle = CommunityType.from(communityTitle)?.value
    }
}

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
    var images: List<String>,
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

data class CreatePostRequest(
    val communityId: Long,
    val title: String,
    val content: String,
    val isQuestion: Boolean,
    val images: List<String>,
) {
    fun toEntity(userId: Long) = Post(
        userId = userId,
        communityId = communityId,
        title = title,
        content = content,
        images = images.map { Image(it) },
        isQuestion = isQuestion,
    )
}

data class MetaData(
    val count: Int,
    val hasMore: Boolean
)

data class PostsResponse(
    val data: List<PostResponse>,
    val meta: MetaData
) {
    companion object {
        fun of(data: List<PostResponse>, limit: Int): PostsResponse {
            return PostsResponse(data, MetaData(limit, data.size >= limit))
        }
    }
}