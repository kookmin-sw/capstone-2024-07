package com.dclass.backend.ui.api

import com.dclass.backend.application.RecruitmentCommentService
import com.dclass.backend.application.dto.CommentRequest
import com.dclass.backend.application.dto.CreateRecruitmentCommentRequest
import com.dclass.backend.application.dto.DeleteRecruitmentCommentRequest
import com.dclass.backend.application.dto.RecruitmentCommentResponse
import com.dclass.backend.application.dto.RecruitmentCommentScrollRequest
import com.dclass.backend.application.dto.RecruitmentCommentsResponse
import com.dclass.backend.application.dto.UpdateRecruitmentCommentRequest
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.responses.ApiResponse
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@Tag(name = "RecruitmentComment", description = "프로젝트/스터디 댓글 관련 API 명세")
@RequestMapping("/api/recruitment-comments")
@RestController
class RecruitmentCommentController(
    private val commentService: RecruitmentCommentService,
) {

    @Operation(summary = "프로젝트/스터디 댓글 생성 API", description = "프로젝트/스터디에 댓글을 생성합니다.")
    @ApiResponse(responseCode = "200", description = "댓글 생성 성공")
    @PostMapping
    fun createComment(
        @LoginUser user: User,
        @RequestBody @Valid request: CreateRecruitmentCommentRequest,
    ): ResponseEntity<RecruitmentCommentResponse> {
        val comment = commentService.create(user.id, request)
        return ResponseEntity.ok(comment)
    }

    @Operation(summary = "프로젝트/스터디 댓글 수정 API", description = "프로젝트/스터디 댓글을 수정합니다.")
    @ApiResponse(responseCode = "204", description = "댓글 수정 성공")
    @PutMapping("/{commentId}")
    fun updateComment(
        @LoginUser user: User,
        @PathVariable commentId: Long,
        @RequestBody request: CommentRequest,
    ): ResponseEntity<Unit> {
        commentService.update(user.id, UpdateRecruitmentCommentRequest(commentId, request.content))
        return ResponseEntity.noContent().build()
    }

    @Operation(summary = "프로젝트/스터디 댓글 삭제 API", description = "프로젝트/스터디 댓글을 삭제합니다.")
    @ApiResponse(responseCode = "204", description = "댓글 삭제 성공")
    @DeleteMapping("/{commentId}")
    fun deleteComment(
        @LoginUser user: User,
        @PathVariable commentId: Long,
    ): ResponseEntity<Unit> {
        commentService.delete(user.id, DeleteRecruitmentCommentRequest(commentId))
        return ResponseEntity.noContent().build()
    }

    @Operation(summary = "프로젝트/스터디 댓글 조회 API", description = "프로젝트/스터디에 달린 댓글을 조회합니다.")
    @ApiResponse(responseCode = "200", description = "댓글 조회 성공")
    @GetMapping
    fun getComments(
        @LoginUser user: User,
        request: RecruitmentCommentScrollRequest,
    ): ResponseEntity<RecruitmentCommentsResponse> {
        val comments = commentService.findAll(user.id, request)
        return ResponseEntity.ok(comments)
    }
}
