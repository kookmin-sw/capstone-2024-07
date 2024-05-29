package com.dclass.backend.ui.api

import com.dclass.backend.application.ReportService
import com.dclass.backend.application.dto.UpdateReportRequest
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RequestMapping("/api/report")
@RestController
class ReportController(
    private val reportService: ReportService,
) {
    @PostMapping
    fun update(
        @LoginUser user: User,
        @RequestBody request: UpdateReportRequest,
    ): ResponseEntity<Unit> {
        reportService.report(user.id, request)
        return ResponseEntity.noContent().build()
    }
}
