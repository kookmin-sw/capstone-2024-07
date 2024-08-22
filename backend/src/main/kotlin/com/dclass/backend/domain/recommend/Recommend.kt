package com.dclass.backend.domain.recommend

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity

@Entity
class Recommend(
    @Column(nullable = false)
    val userName: String,
    id: Long = 0L,
) : BaseEntity(id)
