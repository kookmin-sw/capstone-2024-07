package com.dclass.backend.domain.recruitmentcomment

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Version
import org.hibernate.annotations.SQLDelete
import org.hibernate.annotations.SQLRestriction
import java.time.LocalDateTime

@SQLDelete(sql = "update recruitment_comment set deleted = true where id = ? and version = ?")
@SQLRestriction("deleted = false OR (deleted = true AND reply_count > 0)")
@Entity
class RecruitmentComment(
    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val recruitmentId: Long,

    content: String = "",

    isAnonymous : Boolean = false,

    @Column(nullable = false)
    val createdDateTime: LocalDateTime = LocalDateTime.now(),

    @Version
    val version: Long = 0L,

    modifiedDateTime: LocalDateTime = LocalDateTime.now(),

    id: Long = 0L,
) : BaseEntity(id) {
    @Column(nullable = false)
    private var deleted: Boolean = false

    @Column(nullable = false, length = 255)
    var content: String = content
        private set

    @Column(nullable = false)
    var isAnonymous: Boolean = isAnonymous
        private set

    @Column(nullable = false)
    var modifiedDateTime: LocalDateTime = modifiedDateTime
        private set

    @Column(nullable = false)
    var replyCount: Int = 0
        private set

    fun isDeleted() = deleted

    fun changeContent(content: String) {
        this.content = content
        modifiedDateTime = LocalDateTime.now()
    }

    fun increaseReplyCount() {
        replyCount++
    }

    fun decreaseReplyCount() {
        replyCount--
    }
}
