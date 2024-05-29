package com.dclass.backend.domain.belong

import com.dclass.backend.exception.belong.BelongException
import com.dclass.backend.exception.belong.BelongExceptionType.CHANGE_INTERVAL_VIOLATION
import com.dclass.backend.exception.belong.BelongExceptionType.MAX_BELONG
import com.dclass.support.domain.BaseEntity
import jakarta.persistence.*
import org.hibernate.annotations.SQLDelete
import org.hibernate.annotations.SQLRestriction
import java.time.Duration
import java.time.LocalDateTime

@SQLDelete(sql = "update belong set deleted = true where id = ?")
@SQLRestriction("deleted = false")
@Entity
@Table
class Belong(
    @Column(nullable = false, unique = true)
    val userId: Long,

    ids: List<Long> = emptyList(),

    modifiedDateTime: LocalDateTime = LocalDateTime.now(),

    id: Long = 0L,
) : BaseEntity(id) {

    @Column(nullable = false)
    private var deleted: Boolean = false

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "join_department")
    private val _departmentIds: MutableList<Long> = ids.toMutableList()

    val departmentIds: List<Long>
        get() = _departmentIds

    @Column(nullable = false)
    var modifiedDateTime: LocalDateTime = modifiedDateTime
        private set

    val activated: Long
        get() = _departmentIds.first()

    val remainingTime: Duration
        get() = Duration.between(
            LocalDateTime.now(),
            modifiedDateTime.plusDays(CHANGE_INTERVAL_DAYS),
        ).takeUnless { it.isNegative } ?: Duration.ZERO

    @Column(nullable = false)
    var majorIndex: Int = 0
        private set

    val major: Long
        get() = _departmentIds[majorIndex]

    val minor: Long
        get() = _departmentIds[1 - majorIndex]

    init {
        if (departmentIds.size > 2) {
            throw BelongException(MAX_BELONG)
        }
    }

    fun update(ids: List<Long>) {
        if (ids.size > 2) {
            throw BelongException(MAX_BELONG)
        }
        if (!periodValidation()) {
            throw BelongException(CHANGE_INTERVAL_VIOLATION)
        }
        _departmentIds.clear()
        _departmentIds.addAll(ids)
        modifiedDateTime = LocalDateTime.now()
    }

    fun contain(departmentId: Long) = departmentIds.contains(departmentId)

    fun switch() {
        _departmentIds.reverse()
        majorIndex = 1 - majorIndex
    }

    private fun periodValidation(): Boolean {
        val now = LocalDateTime.now()
        return modifiedDateTime.isBefore(now.minusDays(CHANGE_INTERVAL_DAYS))
    }

    companion object {
        const val CHANGE_INTERVAL_DAYS = 90L
    }
}
