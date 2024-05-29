package com.dclass.backend.application

import com.dclass.backend.application.dto.UpdateReportRequest
import com.dclass.backend.domain.report.ReportEvent
import com.dclass.backend.domain.report.ReportRepository
import jakarta.transaction.Transactional
import org.springframework.context.ApplicationEventPublisher
import org.springframework.stereotype.Service

@Transactional
@Service
class ReportService(
    private val reportRepository: ReportRepository,
    private val eventPublisher: ApplicationEventPublisher,
) {
    fun report(userId: Long, request: UpdateReportRequest) {
        reportRepository.findByReporterIdAndAndReportedObjectId(userId, request.reportedObjectId)?.let {
            reportRepository.delete(it)
        }
        reportRepository.save(request.toEntity(userId))

        removeIfReportAccumulated(request)
    }

    private fun removeIfReportAccumulated(request: UpdateReportRequest) {
        val reportCount = reportRepository.countReportById(request.reportedObjectId, request.reportType)
        if (reportCount >= 10) {
            eventPublisher.publishEvent(ReportEvent.create(request.reportedObjectId, request.reportType))
        }
    }
}
