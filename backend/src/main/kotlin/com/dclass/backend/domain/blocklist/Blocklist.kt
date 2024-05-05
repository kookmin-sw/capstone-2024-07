package com.dclass.backend.domain.blocklist

import com.dclass.backend.exception.blocklist.BlocklistException
import com.dclass.backend.exception.blocklist.BlocklistExceptionType
import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity
import java.time.Duration
import java.time.LocalDateTime

@Entity
class Blocklist(

    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val createdDateTime: LocalDateTime = LocalDateTime.now(),

    id: Long = 0L
) : BaseEntity(id) {

    val remainingTime: Duration
        get() = Duration.between(
            LocalDateTime.now(),
            createdDateTime.plusDays(CHANGE_INTERVAL_DAYS)
        ).takeUnless { it.isNegative } ?: Duration.ZERO

    fun isExpired(): Boolean = remainingTime.isZero

    fun validate() {
        if (!isExpired()) throw BlocklistException(BlocklistExceptionType.BLOCKED_USER)
    }

    companion object {
        const val CHANGE_INTERVAL_DAYS = 90L
    }
}