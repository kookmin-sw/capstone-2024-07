package com.dclass.backend.application.dto

import com.dclass.backend.domain.report.Report
import com.dclass.backend.domain.report.ReportReason
import com.dclass.backend.domain.report.ReportType

data class UpdateReportRequest(
    val reportedObjectId: Long,
    val reportType: ReportType,
    val reason: ReportReason
){
    fun toEntity(reporterId: Long) = Report(reporterId, reportedObjectId, reportType, reason)
}