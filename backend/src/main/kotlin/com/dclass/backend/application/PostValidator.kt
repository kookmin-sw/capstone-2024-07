package com.dclass.backend.application

import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.join.JoinRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class PostValidator(
    private val joinRepository: JoinRepository,
    private val communityRepository: CommunityRepository
) {
    fun validateCreatePost(userId: Long, communityId: Long) {
        val join = joinRepository.findByUserId(userId)
        val community = communityRepository.findByIdOrNull(communityId)
        check(join.contain(communityId)) { "해당 커뮤니티에 게시글을 작성할 수 없습니다." }
    }
}
