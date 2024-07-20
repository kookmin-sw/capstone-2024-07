package com.dclass.backend.domain.recruitment

import org.springframework.data.jpa.repository.JpaRepository

interface RecruitmentRepository : JpaRepository<Recruitment, Long>, RecruitmentRepositorySupport
