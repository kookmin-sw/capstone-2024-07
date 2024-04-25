package com.dclass.support.fixtures

import com.dclass.backend.domain.scrap.Scrap

fun scrap(
    userId: Long = 1L,
    postId: Long = 1L,
): Scrap {
    return Scrap(
        userId = userId,
        postId = postId,
    )
}
