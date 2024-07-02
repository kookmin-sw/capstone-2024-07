package com.dclass.backend.domain.recruitment

import jakarta.persistence.Column
import jakarta.persistence.Embeddable

@Embeddable
class RecruitmentLike(
    @Column(nullable = false)
    val usersId: Long,
)
