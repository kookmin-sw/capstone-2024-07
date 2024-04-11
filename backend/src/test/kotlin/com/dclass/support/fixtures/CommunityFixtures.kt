package com.dclass.support.fixtures

import com.dclass.backend.domain.community.Community

fun community(
    departmentId: Long = 1L,
    title: String = "FREE",
    description: String = "자유롭게 이야기할 수 있는 게시판입니다"
): Community {
    return Community(
        departmentId = departmentId,
        title = title,
        description = description,
    )
}