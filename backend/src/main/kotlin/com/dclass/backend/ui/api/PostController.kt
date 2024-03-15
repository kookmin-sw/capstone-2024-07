package com.dclass.backend.ui.api

import com.dclass.backend.application.PostService
import com.dclass.backend.application.dto.CreatePostRequest
import com.dclass.backend.application.dto.PostResponse
import com.dclass.backend.application.dto.PostScrollPageRequest
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*


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

    @GetMapping
    fun getPosts(
        @LoginUser user: User,
        request: PostScrollPageRequest
    ): ResponseEntity<ApiResponses<List<PostResponse>>> {
        return ResponseEntity.ok(ApiResponses.success(postService.getAll(user.id, request)))
    }

    @PostMapping
    fun createPost(
        @LoginUser user: User,
        request: CreatePostRequest
    ): ResponseEntity<ApiResponses<PostResponse>> {
        return ResponseEntity.ok(ApiResponses.success(postService.create(user.id, request)))
    }
}