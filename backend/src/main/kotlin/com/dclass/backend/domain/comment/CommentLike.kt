package com.dclass.backend.domain.comment

import jakarta.persistence.Column
import jakarta.persistence.Embeddable

@Embeddable
class CommentLike(
    @Column(nullable = false)
    val usersId: Long,
)
