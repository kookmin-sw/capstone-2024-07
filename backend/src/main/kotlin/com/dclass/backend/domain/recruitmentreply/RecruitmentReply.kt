package com.dclass.backend.domain.recruitmentreply

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity
import org.hibernate.annotations.SQLDelete
import org.hibernate.annotations.SQLRestriction
import java.time.LocalDateTime

@SQLDelete(sql = "update recruitment_reply set deleted = true where id = ?")
@SQLRestriction("deleted = false")
@Entity
class RecruitmentReply(
    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val recruitmentCommentId: Long,

    content: String = "",

//    isAnonymous: Boolean = false,

    @Column(nullable = false)
    val createdDateTime: LocalDateTime = LocalDateTime.now(),

    modifiedDateTime: LocalDateTime = LocalDateTime.now(),

    id: Long = 0L,
) : BaseEntity(id) {
    @Column(nullable = false)
    private var deleted: Boolean = false

    @Column(nullable = false, length = 255)
    var content: String = content
        private set

    // TODO : 익명 여부 추가
//    @Column(nullable = false)
//    var isAnonymous: Boolean = isAnonymous
//        private set

    @Column(nullable = false)
    var modifiedDateTime: LocalDateTime = modifiedDateTime
        private set

    fun changeContent(content: String) {
        this.content = content
        modifiedDateTime = LocalDateTime.now()
    }
}
