package com.dclass.backend.ui.api

import com.dclass.backend.application.BelongService
import com.dclass.backend.application.dto.SwitchDepartmentResponse
import com.dclass.backend.application.dto.UpdateDepartmentRequest
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.responses.ApiResponse
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RequestMapping("/api/belongs")
@RestController
class BelongController(
    private val belongService: BelongService,
) {

    @Operation(summary = "활성화된 학과 변경 API", description = "활성화된 학과를 변경합니다")
    @ApiResponse(responseCode = "200", description = "학과 변경 성공")
    @PutMapping("/switch-departments")
    fun switchDepartments(
        @LoginUser user: User
    ): ResponseEntity<ApiResponses<SwitchDepartmentResponse>> {
        return ResponseEntity.ok(ApiResponses.success(belongService.switchDepartment(user.id)))
    }

    @Operation(summary = "학과 변경 API", description = "학과를 변경합니다")
    @ApiResponse(responseCode = "204", description = "학과 변경 성공")
    @PutMapping("/change-departments")
    fun changeDepartments(
        @RequestBody @Valid request: UpdateDepartmentRequest,
        @LoginUser user: User
    ): ResponseEntity<Unit> {
        belongService.editDepartments(user.id, request)
        return ResponseEntity.noContent().build()
    }
}