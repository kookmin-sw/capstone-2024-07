package com.dclass.backend.ui.api

import com.dclass.backend.application.RecruitmentReplyService
import com.dclass.backend.application.dto.CreateRecruitmentReplyRequest
import com.dclass.backend.application.dto.DeleteRecruitmentReplyRequest
import com.dclass.backend.application.dto.RecruitmentReplyResponse
import com.dclass.backend.application.dto.ReplyRequest
import com.dclass.backend.application.dto.UpdateRecruitmentReplyRequest
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.responses.ApiResponse
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@Tag(name = "RecruitmentReply", description = "프로젝트/스터디 대댓글 관련 API 명세")
@RequestMapping("/api/recruitment-replies")
@RestController
class RecruitmentReplyController (
    private val replyService: RecruitmentReplyService,
){

    @Operation(summary = "프로젝트/스터디 대댓글 생성 API", description = "프로젝트/스터디 댓글에 대댓글을 생성합니다.")
    @ApiResponse(responseCode = "200", description = "대댓글 생성 성공")
    @PostMapping
    fun createReply(
        @LoginUser user: User,
        @RequestBody @Valid request: CreateRecruitmentReplyRequest,
    ): ResponseEntity<RecruitmentReplyResponse> {
        val reply = replyService.create(user.id, request)
        return ResponseEntity.ok(reply)
    }

    @Operation(summary = "프로젝트/스터디 대댓글 수정 API", description = "프로젝트/스터디 대댓글을 수정합니다.")
    @ApiResponse(responseCode = "204", description = "대댓글 수정 성공")
    @PutMapping("/{replyId}")
    fun updateReply(
        @LoginUser user: User,
        @PathVariable replyId: Long,
        @RequestBody request: ReplyRequest,
    ): ResponseEntity<Unit> {
        replyService.update(user.id, UpdateRecruitmentReplyRequest(replyId, request.content))
        return ResponseEntity.noContent().build()
    }

    @Operation(summary = "프로젝트/스터디 대댓글 삭제 API", description = "프로젝트/스터디 대댓글을 삭제합니다.")
    @ApiResponse(responseCode = "204", description = "대댓글 삭제 성공")
    @DeleteMapping("/{replyId}")
    fun deleteReply(
        @LoginUser user: User,
        @PathVariable replyId: Long,
    ): ResponseEntity<Unit> {
        replyService.delete(user.id, DeleteRecruitmentReplyRequest(replyId))
        return ResponseEntity.noContent().build()
    }
}
