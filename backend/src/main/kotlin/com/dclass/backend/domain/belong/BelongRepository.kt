package com.dclass.backend.domain.belong

import com.dclass.backend.exception.belong.BelongException
import com.dclass.backend.exception.belong.BelongExceptionType
import org.springframework.data.jpa.repository.JpaRepository

fun BelongRepository.getOrThrow(userId: Long): Belong = findByUserId(userId)
    ?: throw BelongException(BelongExceptionType.NOT_FOUND_BELONG)



interface BelongRepository : JpaRepository<Belong, Long> {
    fun findByUserId(userId: Long): Belong?
}