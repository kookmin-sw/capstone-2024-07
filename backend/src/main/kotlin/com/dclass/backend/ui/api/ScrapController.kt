package com.dclass.backend.ui.api

import com.dclass.backend.application.ScrapService
import com.dclass.backend.application.dto.PostResponse
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.responses.ApiResponse
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@Tag(name = "Scrap", description = "스크랩 관련 API 명세")
@RequestMapping("/api/scrap")
@RestController
class ScrapController(
    private val scrapService: ScrapService,
) {

    @Operation(summary = "스크랩 조회 API", description = "스크랩한 게시물을 조회합니다.")
    @ApiResponse(responseCode = "200", description = "스크랩 조회 성공")
    @GetMapping
    fun readAll(@LoginUser user: User): ResponseEntity<List<PostResponse>> {
        val scrap = scrapService.getAll(user.id)
        return ResponseEntity.ok(scrap)
    }

    @Operation(summary = "스크랩 생성 API", description = "게시물을 스크랩합니다.")
    @ApiResponse(responseCode = "204", description = "스크랩 생성 성공")
    @PostMapping
    fun create(@LoginUser user: User, postId: Long): ResponseEntity<Unit> {
        scrapService.create(user.id, postId)
        return ResponseEntity.noContent().build()
    }

    @Operation(summary = "스크랩 삭제 API", description = "스크랩한 게시물을 삭제합니다.")
    @ApiResponse(responseCode = "204", description = "스크랩 삭제 성공")
    @DeleteMapping("/{postId}")
    fun delete(@LoginUser user: User, @PathVariable postId: Long): ResponseEntity<Unit> {
        scrapService.delete(user.id, postId)
        return ResponseEntity.noContent().build()
    }
}
