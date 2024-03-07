package com.dclass.backend.application.dto


data class PostScrollPageRequest(
    val lastId: Long?,
    val communityId: Long,
    val size: Int,
)

