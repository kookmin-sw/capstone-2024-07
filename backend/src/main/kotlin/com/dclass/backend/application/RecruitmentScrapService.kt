package com.dclass.backend.application

import com.dclass.backend.domain.recruitment.RecruitmentRepository
import com.dclass.backend.domain.recruitment.findByIdOrThrow
import com.dclass.backend.domain.recruitmentscrap.RecruitmentScrap
import com.dclass.backend.domain.recruitmentscrap.RecruitmentScrapRepository
import com.dclass.backend.exception.recruitmentscrap.RecruitmentScrapException
import com.dclass.backend.exception.recruitmentscrap.RecruitmentScrapExceptionType.NOT_FOUND_RECRUITMENT_SCRAP
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class RecruitmentScrapService(
    private val recruitmentRepository: RecruitmentRepository,
    private val recruitmentScrapRepository: RecruitmentScrapRepository,
) {
    fun create(userId: Long, recruitmentId: Long) {
        val recruitment = recruitmentRepository.findByIdOrThrow(recruitmentId)
        recruitment.increaseScrapCount()

        recruitmentScrapRepository.save(RecruitmentScrap(userId, recruitmentId))
    }

    fun delete(userId: Long, recruitmentId: Long) {
        val recruitmentScrap = recruitmentScrapRepository.findByUserIdAndRecruitmentId(userId, recruitmentId)
            ?: throw RecruitmentScrapException(NOT_FOUND_RECRUITMENT_SCRAP)
        val recruitment = recruitmentRepository.findByIdOrThrow(recruitmentId)
        recruitment.decreaseScrapCount()

        recruitmentScrapRepository.delete(recruitmentScrap)
    }
}
