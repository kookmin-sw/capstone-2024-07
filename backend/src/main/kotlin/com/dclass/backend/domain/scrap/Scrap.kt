package com.dclass.backend.domain.scrap

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table

@Entity
@Table
class Scrap(
    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val postId: Long,
    id: Long = 0L,
) : BaseEntity(id)