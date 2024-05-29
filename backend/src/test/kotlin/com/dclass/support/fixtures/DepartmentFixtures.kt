package com.dclass.support.fixtures

import com.dclass.backend.domain.department.Department

fun department(
    id: Long = 1L,
    title: String = "컴퓨터공학과",
): Department {
    return Department(
        id = id,
        title = title,
    )
}
