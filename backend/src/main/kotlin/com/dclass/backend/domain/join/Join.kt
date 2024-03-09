package com.dclass.backend.domain.join

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table
class Join(
    @Column(nullable = false)
    val userId: Long,

    departments: List<Long> = emptyList(),

    modifiedDateTime: LocalDateTime = LocalDateTime.now(),
    id: Long = 0L
) : BaseEntity(id) {

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "join_department")
    private val _departmentIds: MutableList<Long> = departments.toMutableList()

    @Column(nullable = false)
    var modifiedDateTime: LocalDateTime = modifiedDateTime
        private set

    val activated: Long
        get() = _departmentIds.first()

    fun update(ids: List<Long>) {
        require(ids.size <= 2) { "학과는 최대 두개까지 선택가능합니다" }
        check(periodValidation()) { "학과 변경은 90일마다 가능합니다." }
        _departmentIds.clear()
        _departmentIds.addAll(ids)
        modifiedDateTime = LocalDateTime.now()
    }

    fun contain(departmentId: Long) = activated == departmentId

    fun switch() {
        _departmentIds.reverse()
    }

    private fun periodValidation(): Boolean {
        val now = LocalDateTime.now()
        return modifiedDateTime.isBefore(now.minusDays(90))
    }
}
