package com.dclass.backend.domain.recruitment

import com.dclass.backend.exception.recruitment.RecruitmentException
import com.dclass.backend.exception.recruitment.RecruitmentExceptionType
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.repository.findByIdOrNull

fun RecruitmentRepository.findByIdOrThrow(id: Long): Recruitment {
    return findByIdOrNull(id) ?: throw RecruitmentException(RecruitmentExceptionType.NOT_FOUND_RECRUITMENT)
}

interface RecruitmentRepository : JpaRepository<Recruitment, Long>, RecruitmentRepositorySupport
