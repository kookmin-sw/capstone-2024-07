package com.dclass.backend.application.dto

import io.swagger.v3.oas.annotations.media.Schema

data class SwitchDepartmentResponse(
    @Schema(description = "활성화된 학과 이름", example = "컴퓨터공학과")
    val activated: String,
)

data class UpdateDepartmentRequest(
    @Schema(description = "변경할 전공의 이름", example = "컴퓨터공학과")
    val major: String,

    @Schema(description = "변경할 부전공의 이름", example = "경영학과")
    val minor: String,
)