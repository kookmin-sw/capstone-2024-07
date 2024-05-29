package com.dclass.backend.domain.report

interface ReportEvent {
    companion object {
        fun create(id: Long, type: ReportType): ReportEvent {
            return when (type) {
                ReportType.POST -> PostReportedEvent(id)
                ReportType.COMMENT -> CommentReportedEvent(id)
                ReportType.REPLY -> ReplyReportedEvent(id)
            }
        }
    }
}

class PostReportedEvent(
    val postId: Long,
) : ReportEvent

class CommentReportedEvent(
    val commentId: Long,
) : ReportEvent

class ReplyReportedEvent(
    val replyId: Long,
) : ReportEvent
