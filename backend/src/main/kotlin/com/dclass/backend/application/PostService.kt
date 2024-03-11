package com.dclass.backend.application

import com.dclass.backend.application.dto.PostResponse
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
    private val awsPresigner: AwsPresigner
) {
    fun getById(userId: Long, postId: Long): PostResponse {
        postValidator.validateGetPost(userId, postId)

        return postRepository.findPostById(postId).apply {
            images = runBlocking(Dispatchers.IO) {
                images.map { async { awsPresigner.getPostObjectPresigned(it) } }.awaitAll()
            }
        }
    }
}