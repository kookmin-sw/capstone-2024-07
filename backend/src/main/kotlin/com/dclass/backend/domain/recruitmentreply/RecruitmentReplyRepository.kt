package com.dclass.backend.domain.recruitmentreply

import com.dclass.backend.exception.reply.ReplyException
import com.dclass.backend.exception.reply.ReplyExceptionType
import org.springframework.data.jpa.repository.JpaRepository

fun RecruitmentReplyRepository.getByIdOrThrow(replyId: Long): RecruitmentReply {
    return findById(replyId).orElseThrow()
}

fun RecruitmentReplyRepository.getByIdAndUserIdOrThrow(replyId: Long, userId: Long): RecruitmentReply {
    return findByIdAndUserId(replyId, userId) ?: throw ReplyException(ReplyExceptionType.NOT_FOUND_REPLY)
}

interface RecruitmentReplyRepository : JpaRepository<RecruitmentReply, Long>, RecruitmentReplyRepositorySupport {
    fun findByIdAndUserId(replyId: Long, userId: Long): RecruitmentReply?
}
