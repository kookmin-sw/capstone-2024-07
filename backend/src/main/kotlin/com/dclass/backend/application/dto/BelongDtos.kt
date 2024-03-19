package com.dclass.backend.application.dto

import io.swagger.v3.oas.annotations.media.Schema

data class SwitchDepartmentResponse(
    @Schema(description = "활성화된 학과 이름", example = "컴퓨터공학과")
    val activated: String,
)

data class UpdateDepartmentRequest(
    val major: String,
    val minor: String,
)