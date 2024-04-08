package com.dclass.backend.application

import com.dclass.backend.application.dto.PostResponse
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.findByIdOrThrow
import com.dclass.backend.domain.scrap.Scrap
import com.dclass.backend.domain.scrap.ScrapRepository
import com.dclass.backend.exception.scrap.ScrapException
import com.dclass.backend.exception.scrap.ScrapExceptionType.NOT_FOUND_SCRAP
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class ScrapService(
    private val scrapRepository: ScrapRepository,
    private val postRepository: PostRepository,
    private val validator: ScrapValidator
) {

    fun create(userId: Long, postId: Long) {
        val post = validator.validateScrapPost(userId, postId)
        post.increaseScrapCount()

        scrapRepository.save(Scrap(userId, postId))
    }

    fun delete(userId: Long, postId: Long) {
        val scrap = scrapRepository.findByUserIdAndPostId(userId, postId) ?: throw ScrapException(
            NOT_FOUND_SCRAP
        )
        val post = postRepository.findByIdOrThrow(postId)
        post.decreaseScrapCount()

        scrapRepository.delete(scrap)
    }

    fun getAll(userId: Long): List<PostResponse> {
        return postRepository.findScrapPostByUserId(userId)
    }
}