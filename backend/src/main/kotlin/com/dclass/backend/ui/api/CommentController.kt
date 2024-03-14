package com.dclass.backend.ui.api

import com.dclass.backend.application.CommentService
import com.dclass.backend.application.dto.*
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.responses.ApiResponse
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@Tag(name = "Comment", description = "댓글 관련 API 명세")
@RequestMapping("/api/comments")
@RestController
class CommentController(
    private val commentService: CommentService
) {

    @Operation(summary = "댓글 생성 API", description = "게시글에 댓글을 생성합니다.")
    @ApiResponse(responseCode = "200", description = "댓글 생성 성공")
    @PostMapping("/{postId}")
    fun createComment(
        @LoginUser user: User,
        @PathVariable postId: Long,
        @RequestBody @Valid request: CommentRequest
    ): ResponseEntity<ApiResponses<CommentResponse>> {
        val comment = commentService.create(user.id, CreateCommentRequest(postId, request.content))
        return ResponseEntity.ok(ApiResponses.success(comment))
    }

    @Operation(summary = "댓글 수정 API", description = "댓글을 수정합니다.")
    @ApiResponse(responseCode = "204", description = "댓글 수정 성공")
    @PutMapping("/{commentId}")
    fun updateComment(
        @LoginUser user: User,
        @PathVariable commentId: Long,
        @RequestBody request: CommentRequest
    ): ResponseEntity<Unit> {
        commentService.update(user.id, UpdateCommentRequest(commentId, request.content))
        return ResponseEntity.noContent().build()
    }

    @Operation(summary = "댓글 삭제 API", description = "댓글을 삭제합니다.")
    @ApiResponse(responseCode = "204", description = "댓글 삭제 성공")
    @DeleteMapping("/{commentId}")
    fun deleteComment(
        @LoginUser user: User,
        @PathVariable commentId: Long
    ): ResponseEntity<Unit> {
        commentService.delete(user.id, DeleteCommentRequest(commentId))
        return ResponseEntity.noContent().build()
    }

    @Operation(summary = "댓글 조회 API", description = "게시글에 달린 댓글을 조회합니다.")
    @ApiResponse(responseCode = "200", description = "댓글 조회 성공")
    @GetMapping("/{postId}")
    fun getComments(
        @LoginUser user: User,
        @PathVariable postId: Long
    ): ResponseEntity<ApiResponses<List<CommentReplyWithUserResponse>>> {
        val comments = commentService.findAllByPostId(postId)
        return ResponseEntity.ok(ApiResponses.success(comments))
    }
}