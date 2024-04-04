package com.dclass.backend.application

import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.community.Community
import com.dclass.backend.exception.comment.CommentException
import com.dclass.backend.exception.comment.CommentExceptionType.FORBIDDEN_COMMENT
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class CommentValidator(
    private val belongRepository: BelongRepository,
) {
    fun validate(userId: Long, community: Community) {
        val belong = belongRepository.getOrThrow(userId)

        if (!belong.contain(community.departmentId)) {
            throw CommentException(FORBIDDEN_COMMENT)
        }
    }
}