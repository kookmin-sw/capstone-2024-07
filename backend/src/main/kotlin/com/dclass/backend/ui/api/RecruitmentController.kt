package com.dclass.backend.ui.api

import com.dclass.backend.application.RecruitmentService
import com.dclass.backend.application.dto.CreateRecruitmentRequest
import com.dclass.backend.application.dto.RecruitmentResponse
import com.dclass.backend.application.dto.RecruitmentScrollPageRequest
import com.dclass.backend.application.dto.RecruitmentWithUserAndHashTagDetailResponse
import com.dclass.backend.application.dto.RecruitmentWithUserAndHashTagResponse
import com.dclass.backend.application.dto.RecruitmentsResponse
import com.dclass.backend.application.dto.UpdateRecruitmentRequest
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.responses.ApiResponse
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@Tag(name = "Recruitment", description = "모집 관련 API 명세")
@RequestMapping("/api/recruitment")
@RestController
class RecruitmentController(
    private val recruitmentService: RecruitmentService,
) {

    @Operation(summary = "모집 조회 API", description = "모집을 조회합니다.")
    @ApiResponse(responseCode = "200", description = "모집 조회 성공")
    @GetMapping("/{recruitmentId}")
    fun getRecruitment(
        @LoginUser user: User,
        @PathVariable recruitmentId: Long,
    ): ResponseEntity<RecruitmentWithUserAndHashTagDetailResponse> {
        val recruitmentResponse = recruitmentService.getById(user.id, recruitmentId)
        return ResponseEntity.ok(recruitmentResponse)
    }

    @Operation(summary = "모집 목록 조회 API", description = "모집 목록을 조회합니다.")
    @ApiResponse(responseCode = "200", description = "모집 목록 조회 성공")
    @GetMapping
    fun getRecruitments(
        @LoginUser user: User,
        request: RecruitmentScrollPageRequest,
    ): ResponseEntity<RecruitmentsResponse> {
        return ResponseEntity.ok(recruitmentService.getAll(user.id, request))
    }

    @Operation(summary = "내 모집 목록 조회 API", description = "내 모집 목록을 조회합니다.")
    @ApiResponse(responseCode = "200", description = "내 모집 목록 조회 성공")
    @GetMapping("/mine")
    fun getMyRecruitments(
        @LoginUser user: User,
        request: RecruitmentScrollPageRequest,
    ): ResponseEntity<RecruitmentsResponse> {
        return ResponseEntity.ok(recruitmentService.getByUserId(user.id, request))
    }

    @Operation(summary = "스크랩한 모집 목록 조회 API", description = "스크랩한 모집 목록을 조회합니다.")
    @ApiResponse(responseCode = "200", description = "스크랩한 모집 목록 조회 성공")
    @GetMapping("/scrapped")
    fun getScrappedRecruitments(
        @LoginUser user: User,
        request: RecruitmentScrollPageRequest,
    ): ResponseEntity<List<RecruitmentWithUserAndHashTagResponse>> {
        return ResponseEntity.ok(recruitmentService.getAllScrapped(user.id))
    }

    // TODO getCommentedRecruitments

    @Operation(summary = "모집 생성 API", description = "모집을 생성합니다.")
    @ApiResponse(responseCode = "200", description = "모집 생성 성공")
    @PostMapping
    fun createRecruitment(
        @LoginUser user: User,
        @RequestBody request: CreateRecruitmentRequest,
    ): ResponseEntity<RecruitmentResponse> {
        return ResponseEntity.ok(recruitmentService.create(user.id, request))
    }

    @Operation(summary = "모집 수정 API", description = "모집을 수정합니다.")
    @ApiResponse(responseCode = "200", description = "모집 수정 성공")
    @PutMapping
    fun updateRecruitment(
        @LoginUser user: User,
        @RequestBody request: UpdateRecruitmentRequest,
    ): ResponseEntity<RecruitmentWithUserAndHashTagDetailResponse> {
        return ResponseEntity.ok(recruitmentService.update(user.id, request))
    }

    @Operation(summary = "모집 삭제 API", description = "모집을 삭제합니다.")
    @ApiResponse(responseCode = "204", description = "모집 삭제 성공")
    @DeleteMapping("/{recruitmentId}")
    fun deleteRecruitment(
        @LoginUser user: User,
        @PathVariable recruitmentId: Long,
    ): ResponseEntity<Unit> {
        recruitmentService.delete(user.id, recruitmentId)
        return ResponseEntity.noContent().build()
    }
}
