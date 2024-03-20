package com.dclass.backend.domain.scrap

import org.springframework.data.jpa.repository.JpaRepository

interface ScrapRepository : JpaRepository<Scrap, Long> {
    fun existsByUserIdAndPostId(userId: Long, postId: Long): Boolean
    fun findByIdAndPostId(userId: Long, postId: Long): Scrap?
}