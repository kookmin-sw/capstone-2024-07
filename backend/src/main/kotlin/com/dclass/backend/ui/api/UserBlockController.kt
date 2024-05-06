package com.dclass.backend.ui.api

import com.dclass.backend.application.UserBlockService
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.responses.ApiResponse
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@Tag(name = "UserBlock", description = "유저 차단 관련 API 명세")
@RequestMapping("/api/block")
@RestController
class UserBlockController(
    private val userBlockService: UserBlockService
) {
    @Operation(summary = "유저 차단 API", description = "사용자를 차단합니다.")
    @ApiResponse(responseCode = "200", description = "사용자 차단 성공")
    @PostMapping
    fun block(@LoginUser user: User, blockedUserId: Long): ResponseEntity<Unit> {
        userBlockService.block(user.id, blockedUserId)
        return ResponseEntity.noContent().build()
    }
}