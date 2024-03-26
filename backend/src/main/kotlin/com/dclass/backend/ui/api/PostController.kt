package com.dclass.backend.ui.api

import com.dclass.backend.application.PostService
import com.dclass.backend.application.dto.*
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.responses.ApiResponse
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@Tag(name = "Post", description = "게시글 관련 API 명세")
@RequestMapping("/api/post")
@RestController
class PostController(
    private val postService: PostService
) {

    @Operation(summary = "게시글 조회 API", description = "게시글을 조회합니다.")
    @ApiResponse(responseCode = "200", description = "게시글 조회 성공")
    @GetMapping("/{postId}")
    fun getPost(
        @LoginUser user: User,
        @PathVariable postId: Long
    ): ResponseEntity<PostResponse> {
        val postResponse = postService.getById(user.id, postId)
        return ResponseEntity.ok(postResponse)
    }

    @Operation(summary = "게시글 목록 조회 API", description = "게시글 목록을 조회합니다.")
    @ApiResponse(responseCode = "200", description = "게시글 목록 조회 성공")
    @GetMapping
    fun getPosts(
        @LoginUser user: User,
        request: PostScrollPageRequest
    ): ResponseEntity<PostsResponse> {
        return ResponseEntity.ok(postService.getAll(user.id, request))
    }

    @Operation(summary = "게시글 생성 API", description = "게시글을 생성합니다.")
    @ApiResponse(responseCode = "200", description = "게시글 생성 성공")
    @PostMapping
    fun createPost(
        @LoginUser user: User,
        @RequestBody request: CreatePostRequest
    ): ResponseEntity<PostResponse> {
        return ResponseEntity.ok(postService.create(user.id, request))
    }

    @Operation(summary = "게시글 좋아요 API", description = "게시글에 좋아요를 누릅니다.")
    @ApiResponse(responseCode = "200", description = "게시글 좋아요 성공")
    @PutMapping("/{postId}")
    fun updateLikes(
        @LoginUser user: User,
        @PathVariable postId: Long
    ): ResponseEntity<Int> {
        return ResponseEntity.ok(postService.likes(user.id, postId))
    }
    
    @Operation(summary = "게시글 수정 API", description = "게시글을 수정합니다.")
    @ApiResponse(responseCode = "204", description = "게시글 수정 성공")
    @PutMapping
    fun updatePost(
        @LoginUser user: User,
        @RequestBody request: UpdatePostRequest
    ): ResponseEntity<Unit> {
        postService.update(user.id, request)
        return ResponseEntity.noContent().build()
    }

    @Operation(summary = "게시글 삭제 API", description = "게시글을 삭제합니다.")
    @ApiResponse(responseCode = "204", description = "게시글 삭제 성공")
    @DeleteMapping("/{postId}")
    fun deletePost(
        @LoginUser user: User,
        @PathVariable postId: Long
    ): ResponseEntity<Unit> {
        postService.delete(user.id, DeletePostRequest(postId))
        return ResponseEntity.noContent().build()
    }
}

