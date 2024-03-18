package com.dclass.backend.domain.belong

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table
class Belong(
    @Column(nullable = false, unique = true)
    val userId: Long,

    ids: List<Long> = emptyList(),

    modifiedDateTime: LocalDateTime = LocalDateTime.now(),

    id: Long = 0L
) : BaseEntity(id) {

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


    @Column(nullable = false)
    var majorIndex: Int = 0
        private set

    val major: Long
        get() = _departmentIds[majorIndex]

    val minor: Long
        get() = _departmentIds[1 - majorIndex]


    init {
        require(departmentIds.size <= 2) { "학과는 최대 두 개까지 선택 가능합니다." }
    }

    fun update(ids: List<Long>) {
        require(ids.size <= 2) { "학과는 최대 두개까지 선택가능합니다" }
        check(periodValidation()) { "학과 변경은 90일마다 가능합니다." }
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
        return modifiedDateTime.isBefore(now.minusDays(90))
    }
}
