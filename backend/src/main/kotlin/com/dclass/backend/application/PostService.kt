package com.dclass.backend.application

import com.dclass.backend.application.dto.*
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.findByIdOrThrow
import com.dclass.backend.domain.scrap.ScrapRepository
import com.dclass.backend.exception.post.PostException
import com.dclass.backend.exception.post.PostExceptionType.NOT_FOUND_POST
import com.dclass.backend.infra.s3.AwsPresigner
import com.dclass.support.domain.Image
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
    private val scrapRepository: ScrapRepository,
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

    fun getByUserId(userId: Long, request: PostScrollPageRequest): PostsResponse {
        val posts = postRepository.findPostScrollPageByUserId(userId, request).onEach {
            it.images = runBlocking(Dispatchers.IO) {
                it.images.map { async { awsPresigner.getPostObjectPresigned(it) } }.awaitAll()
            }
        }

        return PostsResponse.of(posts, request.size)
    }

    fun getScrapped(userId: Long, request: PostScrollPageRequest): PostsResponse {
        val posts = postRepository.findScrapPostByUserId(userId).onEach {
            it.images = runBlocking(Dispatchers.IO) {
                it.images.map { async { awsPresigner.getPostObjectPresigned(it) } }.awaitAll()
            }
        }

        return PostsResponse.of(posts, request.size)
    }

    fun getCommentedAndReplied(userId: Long, request: PostScrollPageRequest): PostsResponse {
        val posts = postRepository.findCommentedAndRepliedPostByUserId(userId, request).onEach {
            it.images = runBlocking(Dispatchers.IO) {
                it.images.map { async { awsPresigner.getPostObjectPresigned(it) } }.awaitAll()
            }
        }

        return PostsResponse.of(posts, request.size)
    }

    fun getById(userId: Long, postId: Long): PostDetailResponse {
        postValidator.validate(userId, postId)

        val post = postRepository.findPostById(postId).apply {
            images = runBlocking(Dispatchers.IO) {
                images.map { async { awsPresigner.getPostObjectPresigned(it) } }.awaitAll()
            }
        }

        post.isScrapped = scrapRepository.existsByUserIdAndPostId(userId, postId)

        return post
    }

    fun create(userId: Long, request: CreatePostRequest): PostDetailResponse {
        val community = postValidator.validateCreatePost(userId, request.communityTitle)

        val post = postRepository.save(request.toEntity(userId, community.id))

        return postRepository.findPostById(post.id).apply {
            images = runBlocking(Dispatchers.IO) {
                images.map { async { awsPresigner.putPostObjectPresigned(it) } }.awaitAll()
            }
        }
    }

    fun update(userId: Long, request: UpdatePostRequest): PostDetailResponse {
        val post = postRepository.findByIdAndUserId(request.postId, userId)
            ?: throw PostException(NOT_FOUND_POST)

        post.update(request.title, request.content, request.images.map { Image(it) })

        val postResponse = postRepository.findPostById(post.id).apply {
            images = runBlocking(Dispatchers.IO) {
                images.map { async { awsPresigner.putPostObjectPresigned(it) } }.awaitAll()
            }
        }

        postResponse.isScrapped = scrapRepository.existsByUserIdAndPostId(userId, post.id)


        return postResponse
    }

    fun delete(userId: Long, request: DeletePostRequest) {
        val post = postRepository.findByIdAndUserId(request.postId, userId)
            ?: throw PostException(NOT_FOUND_POST)
        postRepository.delete(post)
    }

    fun likes(userId: Long, postId: Long): Int {
        postValidator.validate(userId, postId)

        val post = postRepository.findByIdOrThrow(postId)
        post.addLike(userId)

        return post.postLikesCount
    }
}