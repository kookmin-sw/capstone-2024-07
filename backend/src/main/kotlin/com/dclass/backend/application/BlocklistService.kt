package com.dclass.backend.application

import com.dclass.backend.application.dto.RemainDurationResponse
import com.dclass.backend.domain.blocklist.BlocklistRepository
import com.dclass.backend.domain.blocklist.getByUserIdOrThrow
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class BlocklistService(
    private val blocklistRepository: BlocklistRepository
) {
    fun remain(userId: Long): RemainDurationResponse {
        val blocklist = blocklistRepository.getByUserIdOrThrow(userId)
        return RemainDurationResponse(blocklist.remainingTime)
    }
}