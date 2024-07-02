package com.dclass.backend.domain.recruitment

import jakarta.persistence.Embeddable

@Embeddable
data class RecruitmentContactMethod(
    val input: String = "",
    val type: RecruitmentContactMethodType = RecruitmentContactMethodType.GOOGLE_FORM,
)
