package com.dclass.backend.domain.comment

import com.dclass.backend.exception.comment.CommentException
import com.dclass.backend.exception.comment.CommentExceptionType.NOT_FOUND_COMMENT
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.repository.findByIdOrNull

fun CommentRepository.getByIdOrThrow(commentId: Long): Comment {
    return findByIdOrNull(commentId) ?: throw CommentException(NOT_FOUND_COMMENT)
}

interface CommentRepository : JpaRepository<Comment, Long>, CommentRepositorySupport {
    fun findCommentByIdAndUserId(commentId: Long, userId: Long): Comment?
    fun findAllByUserId(userId: Long): List<Comment>
    fun findByIdAndUserId(commentId: Long, userId: Long): Comment?
}