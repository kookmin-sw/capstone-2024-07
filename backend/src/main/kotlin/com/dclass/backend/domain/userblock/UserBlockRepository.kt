package com.dclass.backend.domain.userblock

import org.springframework.data.jpa.repository.JpaRepository

interface UserBlockRepository : JpaRepository<UserBlock, Long> {
    fun findByBlockerUserId(blockerUserId: Long): List<UserBlock>
}
