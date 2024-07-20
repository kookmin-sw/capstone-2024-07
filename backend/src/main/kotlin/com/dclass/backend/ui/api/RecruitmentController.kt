package com.dclass.backend.ui.api

import com.dclass.backend.application.RecruitmentService
import com.dclass.backend.application.dto.CreateRecruitmentRequest
import com.dclass.backend.application.dto.RecruitmentResponse
import com.dclass.backend.application.dto.RecruitmentScrollPageRequest
import com.dclass.backend.application.dto.RecruitmentsResponse
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RequestMapping("/api/recruitment")
@RestController
class RecruitmentController(
    private val recruitmentService: RecruitmentService,
) {

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

    @PostMapping
    fun createRecruitment(
        @LoginUser user: User,
        @RequestBody request: CreateRecruitmentRequest,
    ): ResponseEntity<RecruitmentResponse> {
        return ResponseEntity.ok(recruitmentService.create(user.id, request))
    }
}
