package com.dclass.backend.domain.userblock

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table

@Entity
@Table
class UserBlock(
    @Column(nullable = false)
    val blockerUserId: Long,

    @Column(nullable = false)
    val blockedUserId: Long,

    id: Long = 0L
) : BaseEntity(id)