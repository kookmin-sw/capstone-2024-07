package com.dclass.support.fixtures

import com.dclass.backend.domain.blacklist.Blacklist

fun blacklist(
    id: Long = 1L,
    invalidRefreshToken: String = "invalid",
): Blacklist {
    return Blacklist(
        id = id,
        invalidRefreshToken = invalidRefreshToken,
    )
}
