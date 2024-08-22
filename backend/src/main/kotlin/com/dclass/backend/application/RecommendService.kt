package com.dclass.backend.application

import com.dclass.backend.domain.recommend.Recommend
import com.dclass.backend.domain.recommend.RecommendRepository
import jakarta.transaction.Transactional
import org.springframework.stereotype.Service

@Transactional
@Service
class RecommendService(
    private val recommendRepository: RecommendRepository
) {
    fun create(userName: String) {
        recommendRepository.save(Recommend(userName))
    }
}
