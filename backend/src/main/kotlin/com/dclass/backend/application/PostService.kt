package com.dclass.backend.application

import com.dclass.backend.application.dto.PostResponse
import com.dclass.backend.application.dto.PostScrollPageRequest
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.post.PostRepository
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
    fun getAll(userId: Long, request: PostScrollPageRequest): List<PostResponse> {
        val departmentIds = belongRepository.findByUserId(userId).departmentIds
        val communityIds = communityRepository.findByDepartmentIdIn(departmentIds)
            .map { it.id }

        return postRepository.findPostScrollPage(communityIds, request).onEach {
            it.images = runBlocking(Dispatchers.IO) {
                it.images.map { async { awsPresigner.getPostObjectPresigned(it) } }.awaitAll()
            }
        }
    }

    fun getById(userId: Long, postId: Long): PostResponse {
        postValidator.validateGetPost(userId, postId)

        return postRepository.findPostById(postId).apply {
            images = runBlocking(Dispatchers.IO) {
                images.map { async { awsPresigner.getPostObjectPresigned(it) } }.awaitAll()
            }
        }
    }

    fun getHot(userId: Long, request: PostScrollPageRequest): List<PostResponse> {
        val departmentIds = belongRepository.findByUserId(userId).departmentIds
        val communityIds = communityRepository.findByDepartmentIdIn(departmentIds)
            .map { it.id }

        return postRepository.findHotPostScrollPage(communityIds, request).onEach {
            it.images = runBlocking(Dispatchers.IO) {
                it.images.map { async { awsPresigner.getPostObjectPresigned(it) } }.awaitAll()
            }
        }
    }
}