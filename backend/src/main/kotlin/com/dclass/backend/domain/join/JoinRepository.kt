package com.dclass.backend.domain.join

import org.springframework.data.jpa.repository.JpaRepository

interface JoinRepository : JpaRepository<Join, Long> {
    fun findByUserId(userId: Long): Join
}