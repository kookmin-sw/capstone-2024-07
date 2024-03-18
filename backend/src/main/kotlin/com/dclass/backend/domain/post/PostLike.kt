package com.dclass.backend.domain.post

import jakarta.persistence.Column
import jakarta.persistence.Embeddable

@Embeddable
class PostLike(
    @Column(nullable = false)
    val usersId: Long,
)