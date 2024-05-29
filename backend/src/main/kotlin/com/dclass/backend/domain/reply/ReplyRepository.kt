package com.dclass.backend.domain.reply

import com.dclass.backend.exception.reply.ReplyException
import com.dclass.backend.exception.reply.ReplyExceptionType.NOT_FOUND_REPLY
import org.springframework.data.jpa.repository.JpaRepository

fun ReplyRepository.getByIdOrThrow(id: Long): Reply {
    return findById(id).orElseThrow { ReplyException(NOT_FOUND_REPLY) }
}

fun ReplyRepository.getByIdAndUserIdOrThrow(replyId: Long, userId: Long): Reply {
    return findByIdAndUserId(replyId, userId) ?: throw ReplyException(NOT_FOUND_REPLY)
}

interface ReplyRepository : JpaRepository<Reply, Long>, ReplyRepositorySupport {
    fun findByIdAndUserId(replyId: Long, userId: Long): Reply?
}
