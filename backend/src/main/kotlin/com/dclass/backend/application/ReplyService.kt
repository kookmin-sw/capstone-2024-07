package com.dclass.backend.application

import com.dclass.backend.application.dto.*
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.getByIdOrThrow
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
    private val postRepository: PostRepository,
) {
    fun create(userId: Long, request: CreateReplyRequest): ReplyResponse {
        val comment = replyValidator.validateCreateReply(userId, request.commentId)
        val post = postRepository.getByIdOrThrow(comment.postId)
        post.increaseCommentReplyCount(1)
        return replyRepository.save(request.toEntity(userId))
            .let(::ReplyResponse)
    }

    fun update(userId: Long, request: UpdateReplyRequest) {
        val reply = replyRepository.getByIdAndUserIdOrThrow(request.replyId, userId)
        reply.changeContent(request.content)
    }

    fun delete(userId: Long, request: DeleteReplyRequest) {
        val reply = replyRepository.getByIdAndUserIdOrThrow(request.replyId, userId)
        val comment = replyValidator.validateDeleteReply(userId, reply.commentId)
        val post = postRepository.getByIdOrThrow(comment.postId)
        post.increaseCommentReplyCount(-1)
        replyRepository.delete(reply)
    }

    fun like(userId: Long, request: LikeReplyRequest) {
        replyValidator.validateLikeReply(userId, request.replyId)
        val reply = replyRepository.getByIdOrThrow(request.replyId)
        reply.like(userId)
    }
}