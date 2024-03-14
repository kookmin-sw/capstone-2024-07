package com.dclass.backend.ui.api

import com.dclass.backend.application.CommentService
import com.dclass.backend.application.dto.CommentRequest
import com.dclass.backend.application.dto.CommentResponse
import com.dclass.backend.application.dto.CreateCommentRequest
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


}