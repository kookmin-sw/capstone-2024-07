package com.dclass.backend.domain.report

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.EnumType.STRING
import jakarta.persistence.Enumerated
import jakarta.persistence.Table
import java.time.LocalDateTime

@Entity
@Table
class Report(
    @Column(nullable = false)
    val reporterId: Long,

    @Column(nullable = false)
    val reportedObjectId: Long,

    @Column(nullable = false)
    @Enumerated(value = STRING)
    val reportType: ReportType,

    @Column(nullable = false)
    @Enumerated(value = STRING)
    val reason: ReportReason,

    @Column(nullable = false)
    val createdDateTime: LocalDateTime = LocalDateTime.now(),

    id: Long = 0L
) : BaseEntity(id)