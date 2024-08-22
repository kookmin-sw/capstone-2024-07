package com.dclass.backend.ui.api

import com.dclass.backend.application.RecommendService
import com.dclass.backend.application.dto.RecommendRequest
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/recommend")
class RecommendController(
    private val recommendService: RecommendService,
) {
    @PostMapping
    fun create(@RequestBody request: RecommendRequest) {
        recommendService.create(request.userName)
    }
}
