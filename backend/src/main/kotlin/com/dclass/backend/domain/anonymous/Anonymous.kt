package com.dclass.backend.domain.anonymous

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity

@Entity
class Anonymous (
    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val postId: Long,

    id : Long = 0L
) : BaseEntity(id)
