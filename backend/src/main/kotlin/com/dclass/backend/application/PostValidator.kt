package com.dclass.backend.application

import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.community.getByIdOrThrow
import com.dclass.backend.domain.community.getByTitleOrThrow
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.getByIdOrThrow
import com.dclass.backend.exception.post.PostException
import com.dclass.backend.exception.post.PostExceptionType.FORBIDDEN_POST
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class PostValidator(
    private val belongRepository: BelongRepository,
    private val communityRepository: CommunityRepository,
    private val postRepository: PostRepository
) {
    fun validateCreatePost(userId: Long, communityTitle: String) {
        val belong = belongRepository.getOrThrow(userId)
        val community = communityRepository.getByTitleOrThrow(communityTitle)

        if (!belong.contain(community.departmentId)) {
            throw PostException(FORBIDDEN_POST)
        }
    }

    fun validate(userId: Long, postId: Long) {
        val belong = belongRepository.getOrThrow(userId)
        val post = postRepository.getByIdOrThrow(postId)
        val community = communityRepository.getByIdOrThrow(post.communityId)

        if (!belong.contain(community.departmentId)) {
            throw PostException(FORBIDDEN_POST)
        }
    }
}
