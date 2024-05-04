package com.dclass.backend.domain.blocklist

import com.dclass.backend.exception.blocklist.BlocklistException
import com.dclass.backend.exception.blocklist.BlocklistExceptionType
import org.springframework.data.jpa.repository.JpaRepository
import java.time.LocalDateTime

fun BlocklistRepository.getByUserIdOrThrow(userId: Long): Blocklist = findByUserId(userId)
    ?: throw BlocklistException(BlocklistExceptionType.NOT_FOUND_USER)

interface BlocklistRepository : JpaRepository<Blocklist, Long> {
    fun findByUserId(userId: Long): Blocklist?
    fun findAllByCreatedDateTimeBeforeAndDeletedIsFalse(dateTime: LocalDateTime): List<Blocklist>
    fun deleteAllByCreatedDateTimeBefore(dateTime: LocalDateTime)

}