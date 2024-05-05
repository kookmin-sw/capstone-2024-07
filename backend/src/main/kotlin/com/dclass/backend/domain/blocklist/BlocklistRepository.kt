package com.dclass.backend.domain.blocklist

import com.dclass.backend.exception.blocklist.BlocklistException
import com.dclass.backend.exception.blocklist.BlocklistExceptionType
import org.springframework.data.jpa.repository.JpaRepository

fun BlocklistRepository.getLatestByUserIdOrThrow(userId: Long): Blocklist = findFirstByUserIdOrderByCreatedDateTimeDesc(userId)
    ?: throw BlocklistException(BlocklistExceptionType.NOT_FOUND_USER)

interface BlocklistRepository : JpaRepository<Blocklist, Long> {
    fun findFirstByUserIdOrderByCreatedDateTimeDesc(userId: Long): Blocklist?
}