package com.dclass.backend.ui.api

import com.dclass.backend.application.RecruitmentScrapService
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RequestMapping("/api/recruitment/scrap")
@RestController
class RecruitmentScrapController(
    private val recruitmentScrapService: RecruitmentScrapService,
) {

    @PostMapping
    fun create(@LoginUser user: User, recruitmentId: Long): ResponseEntity<Unit> {
        recruitmentScrapService.create(user.id, recruitmentId)
        return ResponseEntity.noContent().build()
    }

    @DeleteMapping("/{recruitmentId}")
    fun delete(@LoginUser user: User, @PathVariable recruitmentId: Long): ResponseEntity<Unit> {
        recruitmentScrapService.delete(user.id, recruitmentId)
        return ResponseEntity.noContent().build()
    }
}
