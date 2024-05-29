package com.dclass.backend.application

import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.blocklist.BlocklistRepository
import com.dclass.backend.exception.reply.ReplyException
import com.dclass.backend.exception.reply.ReplyExceptionType
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class ReplyValidator(
    private val belongRepository: BelongRepository,
    private val blocklistRepository: BlocklistRepository,
) {
    fun validate(userId: Long, departmentId: Long) {
        blocklistRepository.findFirstByUserIdOrderByCreatedDateTimeDesc(userId)?.validate()

        val belong = belongRepository.getOrThrow(userId)

        if (!belong.contain(departmentId)) {
            throw ReplyException(ReplyExceptionType.FORBIDDEN_REPLY)
        }
    }
}
