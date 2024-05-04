package com.dclass.backend.ui.api

import com.dclass.backend.application.BlocklistService
import com.dclass.backend.application.dto.RemainDurationResponse
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import io.swagger.v3.oas.annotations.Operation
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RequestMapping("/api/blocklists")
@RestController
class BlocklistController(
    private val blocklistService: BlocklistService
) {

    @Operation(summary = "남은 정지 일수 조회 API", description = "남은 정지 일수를 조회합니다")
    @GetMapping("/remain")
    fun remain(
        @LoginUser user: User
    ): ResponseEntity<RemainDurationResponse> {
        return ResponseEntity.ok(blocklistService.remain(user.id))
    }
}