package com.dclass.backend.domain.post

import jakarta.persistence.Embeddable

@Embeddable
class PostCount(
    val commentReplyCount: Int = 0,
    val likeCount: Int = 0,
    val scrapCount: Int = 0,
) {
    fun increaseCommentReplyCount() =
        PostCount(commentReplyCount + 1, likeCount, scrapCount)

    fun decreaseCommentReplyCount() =
        PostCount(commentReplyCount - 1, likeCount, scrapCount)

    fun syncLikeCount(cnt: Int) =
        PostCount(commentReplyCount, cnt, scrapCount)

    fun increaseScrapCount() =
        PostCount(commentReplyCount, likeCount, scrapCount + 1)

    fun decreaseScrapCount() =
        PostCount(commentReplyCount, likeCount, scrapCount - 1)
}
