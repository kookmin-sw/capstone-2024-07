package com.dclass.backend.application

import com.dclass.backend.application.dto.*
import com.dclass.backend.domain.reply.ReplyRepository
import com.dclass.backend.domain.reply.getByIdAndUserIdOrThrow
import com.dclass.backend.domain.reply.getByIdOrThrow
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class ReplyService(
    private val replyRepository: ReplyRepository,
    private val replyValidator: ReplyValidator,
) {
    //TODO ReplyValidator를 추가한다
    fun create(userId: Long, request: CreateReplyRequest): ReplyResponse {
        replyValidator.validateCreateReply(userId, request.commentId)
        return replyRepository.save(request.toEntity(userId))
            .let(::ReplyResponse)
    }

    fun update(userId: Long, request: UpdateReplyRequest) {
        val reply = replyRepository.getByIdAndUserIdOrThrow(request.replyId, userId)
        reply.changeContent(request.content)
    }

    fun delete(userId: Long, request: DeleteReplyRequest) {
        val reply = replyRepository.getByIdAndUserIdOrThrow(request.replyId, userId)

        replyRepository.delete(reply)
    }

    fun like(userId: Long, request: LikeReplyRequest) {
        replyValidator.validateLikeReply(userId, request.replyId)
        val reply = replyRepository.getByIdOrThrow(request.replyId)
        reply.like(userId)
    }
}