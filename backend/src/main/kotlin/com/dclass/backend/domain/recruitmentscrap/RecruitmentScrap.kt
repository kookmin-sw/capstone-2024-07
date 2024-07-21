package com.dclass.backend.domain.recruitmentscrap

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import org.hibernate.annotations.SQLDelete
import org.hibernate.annotations.SQLRestriction

@SQLDelete(sql = "update recruitment_scrap set deleted = true where id = ?")
@SQLRestriction("deleted = false")
@Entity
@Table
class RecruitmentScrap(
    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val recruitmentId: Long,
    id: Long = 0L,
) : BaseEntity(id) {

    @Column(nullable = false)
    private var deleted: Boolean = false
}
