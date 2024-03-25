package com.dclass.support.fixtures

import com.dclass.backend.domain.belong.Belong
import java.time.LocalDateTime

fun belong(
    userId: Long = 1L,
    departmentIds: List<Long> = listOf(1L, 2L),
    modifiedDateTime: LocalDateTime = LocalDateTime.now(),
): Belong {
    return Belong(
        userId = userId,
        ids = departmentIds,
        modifiedDateTime = modifiedDateTime,
    )
}
