package com.dclass.backend.ui.api

import com.dclass.backend.application.PostService
import com.dclass.backend.application.dto.PostResponse
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController


@RequestMapping("/api/post")
@RestController
class PostController(
    private val postService: PostService
) {

    @GetMapping("/{postId}")
    fun getPost(
        @LoginUser user: User,
        @PathVariable postId: Long
    ): ResponseEntity<ApiResponses<PostResponse>> {
        val postResponse = postService.getById(user.id, postId)
        return ResponseEntity.ok(ApiResponses.success(postResponse))
    }
}