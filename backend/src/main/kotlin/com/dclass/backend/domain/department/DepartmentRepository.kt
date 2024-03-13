package com.dclass.backend.domain.department

import org.springframework.data.jpa.repository.JpaRepository

fun DepartmentRepository.getOrThrow(title: String): Department = findByTitle(title)
    ?: throw NoSuchElementException("부서가 존재하지 않습니다. title: $title")

interface DepartmentRepository : JpaRepository<Department, Long> {
    fun findByTitle(title: String): Department?
}