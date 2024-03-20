package com.dclass.backend.ui.api

import com.dclass.backend.application.ReplyService
import com.dclass.backend.application.dto.*
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.responses.ApiResponse
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@Tag(name = "Reply", description = "대댓글 관련 API 명세")
@RequestMapping("/api/replies")
@RestController
class ReplyController(
    private val replyService: ReplyService
) {

    @Operation(summary = "대댓글 생성 API", description = "댓글에 대댓글을 생성합니다.")
    @ApiResponse(responseCode = "200", description = "대댓글 생성 성공")
    @PostMapping
    fun createReply(
        @LoginUser user: User,
        @RequestBody request: CreateReplyRequest
    ): ResponseEntity<ApiResponses<ReplyResponse>> {
        val reply = replyService.create(user.id, request)
        return ResponseEntity.ok(ApiResponses.success(reply))
    }

    @Operation(summary = "대댓글 수정 API", description = "대댓글을 수정합니다.")
    @ApiResponse(responseCode = "204", description = "대댓글 수정 성공")
    @PutMapping("/{replyId}")
    fun updateReply(
        @LoginUser user: User,
        @PathVariable replyId: Long,
        @RequestBody request: ReplyRequest
    ): ResponseEntity<Unit> {
        replyService.update(user.id, UpdateReplyRequest(replyId, request.content))
        return ResponseEntity.noContent().build()
    }

    @Operation(summary = "대댓글 삭제 API", description = "대댓글을 삭제합니다.")
    @ApiResponse(responseCode = "204", description = "대댓글 삭제 성공")
    @DeleteMapping("/{replyId}")
    fun deleteReply(
        @LoginUser user: User,
        @PathVariable replyId: Long
    ): ResponseEntity<Unit> {
        replyService.delete(user.id, DeleteReplyRequest(replyId))
        return ResponseEntity.noContent().build()
    }

    @PostMapping("/likes")
    fun likeReply(
        @LoginUser user: User,
        @RequestBody request: LikeReplyRequest
    ): ResponseEntity<Unit> {
        replyService.like(user.id, request)
        return ResponseEntity.noContent().build()
    }
}