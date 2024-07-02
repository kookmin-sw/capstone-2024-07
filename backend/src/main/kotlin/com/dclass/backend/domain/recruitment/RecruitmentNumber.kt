package com.dclass.backend.domain.recruitment

import jakarta.persistence.Embeddable

@Embeddable
class RecruitmentNumber(
    val number: Int,
) {
    init {
        require(number in -1..9) { "Recruitment number..." }
    }
}
