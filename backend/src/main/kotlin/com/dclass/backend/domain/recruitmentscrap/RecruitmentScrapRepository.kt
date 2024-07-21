package com.dclass.backend.domain.recruitmentscrap

import org.springframework.data.jpa.repository.JpaRepository

interface RecruitmentScrapRepository : JpaRepository<RecruitmentScrap, Long> {
    fun findByUserIdAndRecruitmentId(userId: Long, recruitmentId: Long): RecruitmentScrap?
    fun existsByUserIdAndRecruitmentId(userId: Long, recruitmentId: Long): Boolean
}
