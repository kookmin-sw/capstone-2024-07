package com.dclass.backend.application

import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.blocklist.BlocklistRepository
import com.dclass.backend.domain.community.Community
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.community.findByIdOrThrow
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.findByIdOrThrow
import com.dclass.backend.exception.post.PostException
import com.dclass.backend.exception.post.PostExceptionType.FORBIDDEN_POST
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class PostValidator(
    private val belongRepository: BelongRepository,
    private val communityRepository: CommunityRepository,
    private val postRepository: PostRepository,
    private val blocklistRepository: BlocklistRepository
) {
    fun validate(userId: Long, communityTitle: String): Community {
        blocklistRepository.findFirstByUserIdOrderByCreatedDateTimeDesc(userId)?.validate()

        val belong = belongRepository.getOrThrow(userId)
        val community =
            communityRepository.findByDepartmentIdAndTitle(belong.activated, communityTitle)
                ?: throw PostException(FORBIDDEN_POST)


        if (!belong.contain(community.departmentId)) {
            throw PostException(FORBIDDEN_POST)
        }
        return community
    }

    fun validate(userId: Long, postId: Long) {
        val belong = belongRepository.getOrThrow(userId)
        val post = postRepository.findByIdOrThrow(postId)
        val community = communityRepository.findByIdOrThrow(post.communityId)

        if (!belong.contain(community.departmentId)) {
            throw PostException(FORBIDDEN_POST)
        }
    }
}
