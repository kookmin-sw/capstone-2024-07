package com.dclass.backend.domain.report

import org.springframework.data.jpa.repository.JpaRepository


interface ReportRepository : JpaRepository<Report, Long>, ReportRepositorySupport {
    fun findByReporterIdAndAndReportedObjectId(userId: Long, reportedObjectId: Long): Report?
}