package com.dclass.backend.domain.recruitment

import com.dclass.backend.application.dto.UpdateRecruitmentRequest
import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.EnumType
import jakarta.persistence.Enumerated
import jakarta.persistence.Table
import jakarta.persistence.Version
import org.hibernate.annotations.SQLDelete
import org.hibernate.annotations.SQLRestriction
import java.time.LocalDateTime

@SQLDelete(sql = "update Recruitment set deleted = true where id = ? and version = ?")
@SQLRestriction("deleted = false")
@Entity
@Table
class Recruitment(
    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val departmentId: Long,

    type: RecruitmentType = RecruitmentType.STUDY,

    isOnline: Boolean = false,

    isOngoing: Boolean = false,

    limit: RecruitmentNumber = RecruitmentNumber(-1),

    recruitable: Boolean = true,

    startDateTime: LocalDateTime,

    endDateTime: LocalDateTime,

    title: String = "",

    content: String = "",

    scrapCount: Int = 0,

    commentCount: Int = 0,

    @Column(nullable = false)
    val createdDateTime: LocalDateTime = LocalDateTime.now(),

    @Version
    val version: Long = 0L,

    modifiedDateTime: LocalDateTime = LocalDateTime.now(),

    id: Long = 0L,
) : BaseEntity(id) {

    @Column(nullable = false)
    private var deleted: Boolean = false

    @Column(nullable = false)
    var recruitable: Boolean = recruitable
        private set

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    var type: RecruitmentType = type
        private set

    @Column(nullable = false)
    var isOnline: Boolean = isOnline
        private set

    @Column(nullable = false)
    var isOngoing: Boolean = isOngoing
        private set

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    var limit: RecruitmentNumber = limit
        private set

    @Column(nullable = false)
    var title: String = title
        private set

    @Column(nullable = false)
    var content: String = content
        private set

    @Column(nullable = false)
    var scrapCount: Int = scrapCount
        private set

    @Column(nullable = false)
    var commentCount: Int = commentCount
        private set

    @Column(nullable = false)
    var startDateTime: LocalDateTime = startDateTime
        private set

    @Column(nullable = false)
    var endDateTime: LocalDateTime = endDateTime
        private set

    @Column(nullable = false)
    var modifiedDateTime: LocalDateTime = modifiedDateTime
        private set

    fun increaseScrapCount() {
        scrapCount += 1
    }

    fun decreaseScrapCount() {
        scrapCount -= 1
    }

    fun increaseCommentReplyCount() {
        commentCount += 1
    }

    fun decreaseCommentReplyCount() {
        commentCount -= 1
    }

    fun update(request: UpdateRecruitmentRequest) {
        type = request.type
        isOnline = request.isOnline
        isOngoing = request.isOngoing
        limit = RecruitmentNumber(request.limit)
        recruitable = request.recruitable
        startDateTime = request.startDateTime
        endDateTime = request.endDateTime
        title = request.title
        content = request.content
        modifiedDateTime = LocalDateTime.now()
    }
}
