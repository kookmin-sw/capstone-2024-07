package com.dclass.backend.application

import com.dclass.backend.domain.userblock.UserBlock
import com.dclass.backend.domain.userblock.UserBlockRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class UserBlockService(
    private val userBlockRepository: UserBlockRepository
) {
    fun block(userId: Long, blockedUserId: Long) {
        userBlockRepository.save(UserBlock(userId, blockedUserId))
    }
}