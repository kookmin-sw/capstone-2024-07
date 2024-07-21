package com.dclass.backend.application

import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.blocklist.BlocklistRepository
import com.dclass.backend.exception.comment.CommentException
import com.dclass.backend.exception.comment.CommentExceptionType.*
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class CommentReplyValidator(
    private val belongRepository: BelongRepository,
    private val blocklistRepository: BlocklistRepository,
) {
    fun validate(userId: Long, departmentId: Long) {
        blocklistRepository.findFirstByUserIdOrderByCreatedDateTimeDesc(userId)?.validate()

        val belong = belongRepository.getOrThrow(userId)

        if (!belong.contain(departmentId)) {
            throw CommentException(FORBIDDEN_COMMENT)
        }
    }
}
