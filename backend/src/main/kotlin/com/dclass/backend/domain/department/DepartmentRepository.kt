package com.dclass.backend.domain.department

import com.dclass.backend.exception.department.DepartmentException
import com.dclass.backend.exception.department.DepartmentExceptionType.NOT_FOUND_DEPARTMENT
import org.springframework.data.jpa.repository.JpaRepository

fun DepartmentRepository.getByTitleOrThrow(title: String): Department = findByTitle(title)
    ?: throw DepartmentException(NOT_FOUND_DEPARTMENT)

fun DepartmentRepository.getByIdOrThrow(id: Long): Department =
    findById(id).orElseThrow { DepartmentException(NOT_FOUND_DEPARTMENT) }

interface DepartmentRepository : JpaRepository<Department, Long> {
    fun findByTitle(title: String): Department?
}
