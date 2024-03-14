package com.dclass.backend.ui.api

import com.dclass.backend.application.CommentService
import com.dclass.backend.application.dto.*
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RequestMapping("/api/comments")
@RestController
class CommentController(
    private val commentService: CommentService
) {

    @PostMapping("/{postId}")
    fun createComment(
        @LoginUser user: User,
        @PathVariable postId: Long,
        @RequestBody @Valid request: CommentRequest
    ): ResponseEntity<ApiResponses<CommentResponse>> {
        val comment = commentService.create(user.id, CreateCommentRequest(postId, request.content))
        return ResponseEntity.ok(ApiResponses.success(comment))
    }

    @PutMapping("/{commentId}")
    fun updateComment(
        @LoginUser user: User,
        @PathVariable commentId: Long,
        @RequestBody request: CommentRequest
    ): ResponseEntity<Unit> {
        commentService.update(user.id, UpdateCommentRequest(commentId, request.content))
        return ResponseEntity.noContent().build()
    }

    @DeleteMapping("/{commentId}")
    fun deleteComment(
        @LoginUser user: User,
        @PathVariable commentId: Long
    ): ResponseEntity<Unit> {
        commentService.delete(user.id, DeleteCommentRequest(commentId))
        return ResponseEntity.noContent().build()
    }

    @GetMapping("/{postId}")
    fun getComments(
        @LoginUser user: User,
        @PathVariable postId: Long
    ): ResponseEntity<ApiResponses<List<CommentReplyWithUserResponse>>> {
        val comments = commentService.findAllByPostId(postId)
        return ResponseEntity.ok(ApiResponses.success(comments))
    }
}