package com.dclass.backend.domain.belong

import org.springframework.data.jpa.repository.JpaRepository

interface BelongRepository : JpaRepository<Belong, Long> {
    fun findByUserId(userId: Long): Belong
}