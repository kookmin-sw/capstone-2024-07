package com.dclass.backend.domain.recruitmentReply

import jakarta.persistence.Column
import jakarta.persistence.Embeddable

@Embeddable
class RecruitmentReplyLike(
    @Column(nullable = false)
    val usersId: Long,
)
