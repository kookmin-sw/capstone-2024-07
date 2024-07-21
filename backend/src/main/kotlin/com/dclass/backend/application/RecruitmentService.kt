package com.dclass.backend.application

import com.dclass.backend.application.dto.CreateRecruitmentRequest
import com.dclass.backend.application.dto.RecruitmentResponse
import com.dclass.backend.application.dto.RecruitmentScrollPageRequest
import com.dclass.backend.application.dto.RecruitmentWithUserAndHashTagDetailResponse
import com.dclass.backend.application.dto.RecruitmentWithUserAndHashTagResponse
import com.dclass.backend.application.dto.RecruitmentsResponse
import com.dclass.backend.application.dto.UpdateRecruitmentRequest
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.hashtag.HashTag
import com.dclass.backend.domain.hashtag.HashTagRepository
import com.dclass.backend.domain.hashtag.HashTagTarget.RECRUITMENT
import com.dclass.backend.domain.recruitment.RecruitmentRepository
import com.dclass.backend.domain.recruitment.findByIdOrThrow
import com.dclass.backend.domain.recruitmentscrap.RecruitmentScrapRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class RecruitmentService(
    private val recruitmentRepository: RecruitmentRepository,
    private val belongRepository: BelongRepository,
    private val hashTagRepository: HashTagRepository,
    private val recruitmentScrapRepository: RecruitmentScrapRepository,
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

    fun getAllScrapped(userId: Long): List<RecruitmentWithUserAndHashTagResponse> {
        val recruitments = recruitmentRepository.findScrappedRecruitmentByUserId(userId)
        val hashTags = hashTagRepository.findRecruitmentHashTagByTargetAndTargetIdIn(
            RECRUITMENT,
            recruitments.map { it.id },
        )
            .groupBy { it.targetId }

        return recruitments.map { RecruitmentWithUserAndHashTagResponse(it, hashTags[it.id] ?: emptyList()) }
    }

    // TODO getCommentedAndReplied

    fun getById(userId: Long, recruitmentId: Long): RecruitmentWithUserAndHashTagDetailResponse {
        val recruitment = recruitmentRepository.findRecruitmentById(recruitmentId)
        val hashTags = hashTagRepository.findRecruitmentHashTagByTargetAndTargetId(RECRUITMENT, recruitmentId)
        val scrapped = recruitmentScrapRepository.existsByUserIdAndRecruitmentId(userId, recruitmentId)
        return RecruitmentWithUserAndHashTagDetailResponse(recruitment, hashTags, scrapped)
    }

    fun create(userId: Long, request: CreateRecruitmentRequest): RecruitmentResponse {
        val activatedDepartmentId = belongRepository.getOrThrow(userId).activated
        val recruitment = recruitmentRepository.save(request.toRecruitment(userId, activatedDepartmentId))
        val hashTags = hashTagRepository.saveAll(request.hashTags.map { HashTag(it, RECRUITMENT, recruitment.id) })
        return RecruitmentResponse(recruitment)
    }

    fun update(userId: Long, request: UpdateRecruitmentRequest): RecruitmentWithUserAndHashTagDetailResponse {
        val recruitment = recruitmentRepository.findByIdOrThrow(request.recruitmentId)
        recruitment.update(request)

        val prevIds = hashTagRepository.findRecruitmentHashTagByTargetAndTargetId(RECRUITMENT, recruitment.id)
            .map { it.id }
        hashTagRepository.deleteAllByIdIn(prevIds)
        val hashTags = hashTagRepository.saveAll(request.hashTags.map { HashTag(it, RECRUITMENT, recruitment.id) })

        // 제대로 동작하는지 확인 필요!
        return getById(userId, recruitment.id)
    }

    fun delete(userId: Long, recruitmentId: Long) {
        val recruitment = recruitmentRepository.findByIdOrThrow(recruitmentId)
        recruitmentRepository.delete(recruitment)
    }
}
