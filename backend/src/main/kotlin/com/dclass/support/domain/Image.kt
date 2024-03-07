package com.dclass.support.domain

import jakarta.persistence.Column
import jakarta.persistence.Embeddable

@Embeddable
class Image(
    @Column(nullable = false)
    val imageKey: String
)
