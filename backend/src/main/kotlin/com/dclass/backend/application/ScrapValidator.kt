package com.dclass.backend.application

import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.community.getByIdOrThrow
import com.dclass.backend.domain.post.Post
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.getByIdOrThrow
import com.dclass.backend.domain.scrap.ScrapRepository
import com.dclass.backend.exception.scrap.ScrapException
import com.dclass.backend.exception.scrap.ScrapExceptionType.ALREADY_SCRAP_POST
import com.dclass.backend.exception.scrap.ScrapExceptionType.PERMISSION_DENIED
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class ScrapValidator(
    private val scrapRepository: ScrapRepository,
    private val belongRepository: BelongRepository,
    private val postRepository: PostRepository,
    private val communityRepository: CommunityRepository
) {
    fun validateScrapPost(userId: Long, postId: Long): Post {
        if (scrapRepository.existsByUserIdAndPostId(userId, postId)) {
            throw ScrapException(ALREADY_SCRAP_POST)
        }
        val belong = belongRepository.getOrThrow(userId)
        val post = postRepository.getByIdOrThrow(postId)
        val community = communityRepository.getByIdOrThrow(post.communityId)

        if (!belong.contain(community.departmentId)) {
            throw ScrapException(PERMISSION_DENIED)
        }
        return post
    }
}

