package com.dclass.backend.domain.recruitmentanonymous

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity

@Entity
class RecruitmentAnonymous(
    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val recruitmentId: Long,

    id: Long = 0L
) : BaseEntity(id)

