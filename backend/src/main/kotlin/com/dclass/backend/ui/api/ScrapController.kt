package com.dclass.backend.ui.api

import com.dclass.backend.application.ScrapService
import com.dclass.backend.application.dto.PostResponse
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController("/api/scrap")
class ScrapController(
    private val scrapService: ScrapService
) {

    @GetMapping
    fun readAll(@LoginUser user: User): ResponseEntity<List<PostResponse>> {
        val scrap = scrapService.getAll(user.id)
        return ResponseEntity.ok(scrap)
    }

    @PostMapping
    fun create(@LoginUser user: User, postId: Long): ResponseEntity<Unit> {
        scrapService.create(user.id, postId)
        return ResponseEntity.noContent().build()
    }

    @DeleteMapping("/{postId}")
    fun delete(@LoginUser user: User, @PathVariable postId: Long): ResponseEntity<Unit> {
        scrapService.delete(user.id, postId)
        return ResponseEntity.noContent().build()
    }
}