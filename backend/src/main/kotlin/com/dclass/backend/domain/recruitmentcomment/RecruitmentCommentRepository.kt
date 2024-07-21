package com.dclass.backend.domain.recruitmentcomment

import com.dclass.backend.exception.comment.CommentException
import com.dclass.backend.exception.comment.CommentExceptionType.NOT_FOUND_COMMENT
import org.springframework.data.jpa.repository.JpaRepository

fun RecruitmentCommentRepository.getByIdOrThrow(commentId: Long): RecruitmentComment {
    return findById(commentId).orElseThrow()
}

fun RecruitmentCommentRepository.getByIdAndUserIdOrThrow(commentId: Long, userId: Long): RecruitmentComment {
    return findByIdAndUserId(commentId, userId) ?: throw CommentException(NOT_FOUND_COMMENT)
}

interface RecruitmentCommentRepository : JpaRepository<RecruitmentComment, Long>, RecruitmentCommentRepositorySupport {
    fun findByIdAndUserId(commentId: Long, userId: Long): RecruitmentComment?
}
