package com.dclass.support.fixtures

import com.dclass.backend.application.dto.CreatePostRequest
import com.dclass.backend.application.dto.UpdatePostRequest
import com.dclass.backend.domain.post.Post
import com.dclass.backend.domain.post.PostCount
import com.dclass.support.domain.Image

fun post(
    title: String = "title",
    content: String = "content",
    userId: Long = 1L,
    communityId: Long = 1L,
    images: List<Image> = listOf(
        createImage("post/s3-test1"),
        createImage("post/s3-test2"),
        createImage("post/s3-test3"),
    ),
    postCount: PostCount = postCount(),
): Post {
    return Post(
        title = title,
        content = content,
        userId = userId,
        communityId = communityId,
        images = images,
        postCount = postCount
    )
}

fun postCount(
    replyCount: Int = 30,
    likeCount: Int = 15,
    scrapCount: Int = 0,
): PostCount {
    return PostCount(
        commentReplyCount = replyCount,
        likeCount = likeCount,
        scrapCount = scrapCount
    )
}

fun createPostRequest(
    communityTitle: String = "JOB",
    title: String = "title",
    content: String = "content",
    isQuestion: Boolean = false,
    images: List<String> = listOf(),
): CreatePostRequest {
    return CreatePostRequest(
        communityTitle = communityTitle,
        title = title,
        content = content,
        isQuestion = isQuestion,
        images = images
    )
}

fun updatePostRequest(
    postId: Long = 1L,
    title: String = "수정된 제목",
    content: String = "수정된 내용",
    images: List<String> = listOf(),
): UpdatePostRequest {
    return UpdatePostRequest(
        postId = postId,
        title = title,
        content = content,
        images = images
    )
}
