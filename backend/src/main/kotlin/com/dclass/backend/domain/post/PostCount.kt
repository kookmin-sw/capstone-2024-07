package com.dclass.backend.domain.post

import jakarta.persistence.Embeddable

@Embeddable
class PostCount(
    val viewCount: Int = 0,
    val likeCount: Int = 0,
    val commentReplyCount: Int = 0
) {
    fun increaseViewCount(cnt: Int) = PostCount(viewCount + cnt, likeCount, commentReplyCount)
    fun increaseLikeCount() = PostCount(viewCount, likeCount + 1, commentReplyCount)
    fun increaseCommentReplyCount(cnt : Int) = PostCount(viewCount, likeCount, commentReplyCount + cnt)
}