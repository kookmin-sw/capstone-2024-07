package com.dclass.backend.domain.belong

import org.springframework.data.jpa.repository.JpaRepository

fun BelongRepository.getOrThrow(userId: Long): Belong = findByUserId(userId)
    ?: throw NoSuchElementException("소속이 존재하지 않습니다. userId: $userId")

interface BelongRepository : JpaRepository<Belong, Long> {
    fun findByUserId(userId: Long): Belong?
}