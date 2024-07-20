package com.dclass.backend.application

import com.dclass.backend.application.dto.CreateRecruitmentRequest
import com.dclass.backend.application.dto.RecruitmentResponse
import com.dclass.backend.application.dto.RecruitmentScrollPageRequest
import com.dclass.backend.application.dto.RecruitmentWithUserAndHashTagResponse
import com.dclass.backend.application.dto.RecruitmentsResponse
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.hashtag.HashTag
import com.dclass.backend.domain.hashtag.HashTagRepository
import com.dclass.backend.domain.hashtag.HashTagTarget.RECRUITMENT
import com.dclass.backend.domain.recruitment.RecruitmentRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class RecruitmentService(
    private val recruitmentRepository: RecruitmentRepository,
    private val belongRepository: BelongRepository,
    private val hashTagRepository: HashTagRepository,
) {
    fun getAll(userId: Long, request: RecruitmentScrollPageRequest): RecruitmentsResponse {
        val activatedDepartmentId = belongRepository.getOrThrow(userId).activated
        val recruitments = recruitmentRepository.findRecruitmentScrollPage(activatedDepartmentId, request)
        val hashTags = hashTagRepository.findRecruitmentHashTagByTargetAndTargetIdIn(
            RECRUITMENT,
            recruitments.map { it.id },
        )
            .groupBy { it.targetId }

        val data = recruitments.map { RecruitmentWithUserAndHashTagResponse(it, hashTags[it.id] ?: emptyList()) }

        return RecruitmentsResponse.of(data, request.size)
    }

    fun getByUserId(userId: Long, request: RecruitmentScrollPageRequest): RecruitmentsResponse {
        val recruitments = recruitmentRepository.findRecruitmentScrollPageByUserId(userId, request)
        val hashTags = hashTagRepository.findRecruitmentHashTagByTargetAndTargetIdIn(
            RECRUITMENT,
            recruitments.map { it.id },
        )
            .groupBy { it.targetId }

        val data = recruitments.map { RecruitmentWithUserAndHashTagResponse(it, hashTags[it.id] ?: emptyList()) }

        return RecruitmentsResponse.of(data, request.size)
    }

    fun create(userId: Long, request: CreateRecruitmentRequest): RecruitmentResponse {
        val activatedDepartmentId = belongRepository.getOrThrow(userId).activated
        val recruitment = recruitmentRepository.save(request.toRecruitment(userId, activatedDepartmentId))
        val hashTags = hashTagRepository.saveAll(request.hashTags.map { HashTag(it, RECRUITMENT, recruitment.id) })
        return RecruitmentResponse(recruitment)
    }
}
