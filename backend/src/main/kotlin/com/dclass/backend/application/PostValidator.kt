package com.dclass.backend.application

import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.post.PostRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class PostValidator(
    private val belongRepository: BelongRepository,
    private val communityRepository: CommunityRepository,
    private val postRepository: PostRepository
) {
    fun validateCreatePost(userId: Long, communityId: Long) {
        val belong = belongRepository.getOrThrow(userId)
        val community = communityRepository.findByIdOrNull(communityId)!!
        check(belong.contain(community.departmentId)) { "해당 커뮤니티에 게시글을 작성할 수 없습니다." }
    }

    fun validate(userId: Long, postId: Long) {
        val belong = belongRepository.getOrThrow(userId)
        val post = postRepository.findByIdOrNull(postId)
            ?: throw IllegalArgumentException("해당 게시글이 존재하지 않습니다.")
        val community = communityRepository.findByIdOrNull(post.communityId)!!
        check(belong.contain(community.departmentId)) { "해당 커뮤니티의 게시글을 조회할 수 없습니다." }
    }
}
