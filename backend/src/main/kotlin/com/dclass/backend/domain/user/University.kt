package com.dclass.backend.domain.user

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity

@Entity
class University(

    @Column(nullable = false)
    val name: String,

    @Column(nullable = false)
    val emailSuffix: String,

    /**
     * 학교 로고 이미지 URL을 추가한다
     */
    @Column(nullable = false)
    val logo: String = "",

    id: Long = 0L
) : BaseEntity(id)