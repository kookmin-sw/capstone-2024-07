package com.dclass.backend.domain.user

import org.springframework.data.jpa.repository.JpaRepository

interface UniversityRepository : JpaRepository<University, Long> {
    fun findByName(name: String): University
    fun existsByEmailSuffix(emailSuffix: String): Boolean
    fun findByEmailSuffix(emailSuffix: String): University
}
