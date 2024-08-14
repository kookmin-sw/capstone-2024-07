package com.dclass.backend.domain.recruitmentanonymous

import org.springframework.data.jpa.repository.JpaRepository

interface RecruitmentAnonymousRepository : JpaRepository<RecruitmentAnonymous, Long> {
    fun existsByUserIdAndRecruitmentId(userId: Long, recruitmentId: Long): Boolean
    fun findByRecruitmentId(recruitmentId: Long): List<RecruitmentAnonymous>
}

