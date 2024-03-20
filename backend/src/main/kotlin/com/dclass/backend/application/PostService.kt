package com.dclass.backend.application

import com.dclass.backend.application.dto.CreatePostRequest
import com.dclass.backend.application.dto.PostResponse
import com.dclass.backend.application.dto.PostScrollPageRequest
import com.dclass.backend.application.dto.PostsResponse
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.getByIdOrThrow
import com.dclass.backend.exception.community.CommunityException
import com.dclass.backend.exception.community.CommunityExceptionType.NOT_FOUND_COMMUNITY
import com.dclass.backend.exception.post.PostException
import com.dclass.backend.exception.post.PostExceptionType
import com.dclass.backend.infra.s3.AwsPresigner
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.runBlocking
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class PostService(
    private val postValidator: PostValidator,
    private val postRepository: PostRepository,
    private val belongRepository: BelongRepository,
    private val communityRepository: CommunityRepository,
    private val awsPresigner: AwsPresigner
) {
    fun getAll(userId: Long, request: PostScrollPageRequest): PostsResponse {
        val activatedDepartmentId = belongRepository.getOrThrow(userId).activated
        val communityIds = communityRepository.findByDepartmentId(activatedDepartmentId)
            .map { it.id }

        val posts = postRepository.findPostScrollPage(communityIds, request).onEach {
            it.images = runBlocking(Dispatchers.IO) {
                it.images.map { async { awsPresigner.getPostObjectPresigned(it) } }.awaitAll()
            }
        }

        return PostsResponse.of(posts, request.size)
    }

    fun getById(userId: Long, postId: Long): PostResponse {
        postValidator.validate(userId, postId)

        return postRepository.findPostById(postId).apply {
            images = runBlocking(Dispatchers.IO) {
                images.map { async { awsPresigner.getPostObjectPresigned(it) } }.awaitAll()
            }
        }
    }

    fun create(userId: Long, request: CreatePostRequest): PostResponse {
        val community = postValidator.validateCreatePost(userId, request.communityTitle)

        val post = postRepository.save(request.toEntity(userId, community.id))

        return postRepository.findPostById(post.id).apply {
            images = runBlocking(Dispatchers.IO) {
                images.map { async { awsPresigner.putPostObjectPresigned(it) } }.awaitAll()
            }
        }
    }

    fun likes(userId: Long, postId: Long): Int {
        postValidator.validate(userId, postId)

        val post = postRepository.getByIdOrThrow(postId)
        post.addLike(userId)

        return post.postLikesCount
    }
}