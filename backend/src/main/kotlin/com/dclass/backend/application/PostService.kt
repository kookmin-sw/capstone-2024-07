package com.dclass.backend.application

import com.dclass.backend.application.dto.PostResponse
import com.dclass.backend.domain.post.PostRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class PostService(
    private val postValidator: PostValidator,
    private val postRepository: PostRepository
) {
    fun getById(userId: Long, postId: Long): PostResponse {
        postValidator.validateGetPost(userId, postId)

        return postRepository.findPostById(postId)
    }
}