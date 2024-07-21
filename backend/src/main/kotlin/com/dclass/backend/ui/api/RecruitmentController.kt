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
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RequestMapping("/api/recruitment")
@RestController
class RecruitmentController(
    private val recruitmentService: RecruitmentService,
) {

    @GetMapping("/{recruitmentId}")
    fun getRecruitment(
        @LoginUser user: User,
        @PathVariable recruitmentId: Long,
    ): ResponseEntity<RecruitmentWithUserAndHashTagDetailResponse> {
        val recruitmentResponse = recruitmentService.getById(user.id, recruitmentId)
        return ResponseEntity.ok(recruitmentResponse)
    }

    @GetMapping
    fun getRecruitments(
        @LoginUser user: User,
        request: RecruitmentScrollPageRequest,
    ): ResponseEntity<RecruitmentsResponse> {
        return ResponseEntity.ok(recruitmentService.getAll(user.id, request))
    }

    @GetMapping("/mine")
    fun getMyRecruitments(
        @LoginUser user: User,
        request: RecruitmentScrollPageRequest,
    ): ResponseEntity<RecruitmentsResponse> {
        return ResponseEntity.ok(recruitmentService.getByUserId(user.id, request))
    }

    @GetMapping("/scrapped")
    fun getScrappedRecruitments(
        @LoginUser user: User,
        request: RecruitmentScrollPageRequest,
    ): ResponseEntity<List<RecruitmentWithUserAndHashTagResponse>> {
        return ResponseEntity.ok(recruitmentService.getAllScrapped(user.id))
    }

    // TODO getCommentedRecruitments

    @PostMapping
    fun createRecruitment(
        @LoginUser user: User,
        @RequestBody request: CreateRecruitmentRequest,
    ): ResponseEntity<RecruitmentResponse> {
        return ResponseEntity.ok(recruitmentService.create(user.id, request))
    }

    @PutMapping
    fun updateRecruitment(
        @LoginUser user: User,
        @RequestBody request: UpdateRecruitmentRequest,
    ): ResponseEntity<RecruitmentWithUserAndHashTagDetailResponse> {
        return ResponseEntity.ok(recruitmentService.update(user.id, request))
    }

    @DeleteMapping("/{recruitmentId}")
    fun deleteRecruitment(
        @LoginUser user: User,
        @PathVariable recruitmentId: Long,
    ): ResponseEntity<Unit> {
        recruitmentService.delete(user.id, recruitmentId)
        return ResponseEntity.noContent().build()
    }
}
