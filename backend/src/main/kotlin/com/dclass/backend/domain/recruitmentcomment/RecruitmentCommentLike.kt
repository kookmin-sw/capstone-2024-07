package com.dclass.backend.domain.recruitmentcomment

import jakarta.persistence.Column
import jakarta.persistence.Embeddable

@Embeddable
class RecruitmentCommentLike(
    @Column(nullable = false)
    val usersId: Long,
)
