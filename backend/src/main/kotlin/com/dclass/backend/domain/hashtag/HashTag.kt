package com.dclass.backend.domain.hashtag

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.EnumType
import jakarta.persistence.Enumerated

@Entity
class HashTag(
    val name: String,
    @Enumerated(EnumType.STRING)
    val target: HashTagTarget,
    @Column(nullable = false)
    val targetId: Long,
    id: Long = 0L,
) : BaseEntity(id)
