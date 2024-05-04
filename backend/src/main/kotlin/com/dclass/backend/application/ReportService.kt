package com.dclass.backend.application

import com.dclass.backend.application.dto.UpdateReportRequest
import com.dclass.backend.domain.blocklist.Blocklist
import com.dclass.backend.domain.blocklist.BlocklistRepository
import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.comment.getByIdOrThrow
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.findByIdOrThrow
import com.dclass.backend.domain.reply.ReplyRepository
import com.dclass.backend.domain.reply.getByIdOrThrow
import com.dclass.backend.domain.report.ReportEvent
import com.dclass.backend.domain.report.ReportRepository
import com.dclass.backend.domain.report.ReportType
import jakarta.transaction.Transactional
import org.springframework.context.ApplicationEventPublisher
import org.springframework.stereotype.Service

@Transactional
@Service
class ReportService(
    private val reportRepository: ReportRepository,
    private val blocklistRepository: BlocklistRepository,
    private val commentRepository: CommentRepository,
    private val replyRepository: ReplyRepository,
    private val postRepository: PostRepository,
    private val eventPublisher: ApplicationEventPublisher
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
        if (reportCount >= 2) {
            eventPublisher.publishEvent(ReportEvent.create(request.reportedObjectId, request.reportType))
            addBlocklist(request.reportedObjectId, request.reportType)
        }
    }

    private fun addBlocklist(objectId: Long, type: ReportType) {
        when (type) {
            ReportType.COMMENT -> {
                val comment = commentRepository.getByIdOrThrow(objectId)
                blocklistRepository.save(Blocklist(comment.userId))
            }

            ReportType.REPLY -> {
                val reply = replyRepository.getByIdOrThrow(objectId)
                blocklistRepository.save(Blocklist(reply.userId))
            }

            else -> {
                val post = postRepository.findByIdOrThrow(objectId)
                blocklistRepository.save(Blocklist(post.userId))
            }
        }
    }
}