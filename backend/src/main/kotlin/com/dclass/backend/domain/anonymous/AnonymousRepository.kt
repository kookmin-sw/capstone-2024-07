package com.dclass.backend.domain.anonymous

import org.springframework.data.jpa.repository.JpaRepository

interface AnonymousRepository : JpaRepository<Anonymous, Long> {
    fun existsByUserIdAndPostId(userId: Long, postId: Long): Boolean
    fun findByPostId(postId: Long): List<Anonymous>
}
