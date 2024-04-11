package com.dclass.support.fixtures

import com.dclass.backend.domain.scrap.Scrap

fun scrap(
    userId: Long,
    postId: Long
): Scrap {
    return Scrap(
        userId = userId,
        postId = postId,
    )
}
