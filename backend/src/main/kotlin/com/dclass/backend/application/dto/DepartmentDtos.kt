package com.dclass.backend.application.dto

data class DepartmentDTO(
    val id: Long,
    val title: String,
)

data class DepartmentGroupDTO(
    val groupName: String,
    val departments: List<DepartmentDTO>,
)
