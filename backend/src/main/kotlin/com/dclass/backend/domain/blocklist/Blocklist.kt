package com.dclass.backend.domain.blocklist

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity
import org.hibernate.annotations.SQLDelete
import org.hibernate.annotations.SQLRestriction
import java.time.Duration
import java.time.LocalDateTime

@SQLDelete(sql = "update blocklist set deleted = true where id = ?")
@SQLRestriction("deleted = false")
@Entity
class Blocklist(

    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val createdDateTime: LocalDateTime = LocalDateTime.now(),

    id: Long = 0L
) : BaseEntity(id) {

    @Column(nullable = false)
    private var deleted: Boolean = false

    val remainingTime: Duration
        get() = Duration.between(
            LocalDateTime.now(),
            createdDateTime.plusDays(CHANGE_INTERVAL_DAYS)
        ).takeUnless { it.isNegative } ?: Duration.ZERO

    companion object {
        const val CHANGE_INTERVAL_DAYS = 90L
    }
}