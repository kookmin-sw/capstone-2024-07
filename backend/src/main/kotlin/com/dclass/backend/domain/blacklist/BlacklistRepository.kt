package com.dclass.backend.domain.blacklist

import org.springframework.data.jpa.repository.JpaRepository

interface BlacklistRepository : JpaRepository<Blacklist, Long> {
    fun findByInvalidRefreshToken(token: String): Blacklist?
}
