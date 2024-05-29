package com.dclass.backend.domain.reply

import jakarta.persistence.Column
import jakarta.persistence.Embeddable

@Embeddable
class ReplyLike(
    @Column(nullable = false)
    val usersId: Long,
)
