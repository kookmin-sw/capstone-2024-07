package com.dclass.backend.application

import com.dclass.backend.domain.reply.Reply
import com.dclass.backend.domain.reply.ReplyRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class ReplyService(
    private val replyRepository: ReplyRepository,
) {

    private fun find(replyId: Long, userId: Long): Reply {
        val reply = replyRepository.findReplyByIdAndUserId(replyId, userId)
            ?: throw NoSuchElementException("해당 댓글이 존재하지 않습니다.")
        check(!reply.isDeleted(replyId)) {
            "삭제된 댓글입니다."
        }
        return reply
    }
}