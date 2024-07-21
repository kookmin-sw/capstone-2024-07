package com.dclass.backend.domain.hashtag

import org.springframework.data.jpa.repository.JpaRepository

interface HashTagRepository : JpaRepository<HashTag, Long>, HashTagRepositorySupport {

    fun findRecruitmentHashTagByTargetAndTargetIdIn(target: HashTagTarget, targetIds: List<Long>): List<HashTag>
    fun findRecruitmentHashTagByTargetAndTargetId(target: HashTagTarget, targetId: Long): List<HashTag>
}
