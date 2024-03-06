package com.dclass.backend.domain.comment

import org.springframework.data.jpa.repository.JpaRepository

interface CommentRepository : JpaRepository<Comment, Long> {
    fun findCommentById(commentId: Long) : Comment?
    fun findAllByUserId(userId: Long): List<Comment>
}