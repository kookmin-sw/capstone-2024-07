package com.dclass.support.fixtures

import com.dclass.backend.domain.belong.Belong

fun belong(
    userId: Long = 0L,
    departmentIds: List<Long> = listOf(1L, 2L),
): Belong {
    return Belong(
        userId = userId,
        ids = departmentIds
    )
}
