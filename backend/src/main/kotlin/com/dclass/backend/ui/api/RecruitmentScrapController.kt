package com.dclass.backend.ui.api

import com.dclass.backend.application.RecruitmentScrapService
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.responses.ApiResponse
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@Tag(name = "RecruitmentScrap", description = "모집 스크랩 관련 API 명세")
@RequestMapping("/api/recruitment/scrap")
@RestController
class RecruitmentScrapController(
    private val recruitmentScrapService: RecruitmentScrapService,
) {

    @Operation(summary = "모집 스크랩 생성 API", description = "모집을 스크랩합니다.")
    @ApiResponse(responseCode = "204", description = "모집 스크랩 생성 성공")
    @PostMapping
    fun create(@LoginUser user: User, recruitmentId: Long): ResponseEntity<Unit> {
        recruitmentScrapService.create(user.id, recruitmentId)
        return ResponseEntity.noContent().build()
    }

    @Operation(summary = "모집 스크랩 삭제 API", description = "모집 스크랩을 삭제합니다.")
    @ApiResponse(responseCode = "204", description = "모집 스크랩 삭제 성공")
    @DeleteMapping("/{recruitmentId}")
    fun delete(@LoginUser user: User, @PathVariable recruitmentId: Long): ResponseEntity<Unit> {
        recruitmentScrapService.delete(user.id, recruitmentId)
        return ResponseEntity.noContent().build()
    }
}
