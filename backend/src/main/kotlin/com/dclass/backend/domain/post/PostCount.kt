package com.dclass.backend.domain.post

import jakarta.persistence.Embeddable

@Embeddable
class PostCount(
    val commentReplyCount: Int = 0,
    val likeCount: Int = 0
) {
    fun increaseCommentReplyCount(cnt: Int) =
        PostCount(commentReplyCount + cnt,likeCount)

    fun syncLikeCount(cnt: Int) =
        PostCount(commentReplyCount,cnt)
}