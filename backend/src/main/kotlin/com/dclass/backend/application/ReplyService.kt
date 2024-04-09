package com.dclass.backend.application

import com.dclass.backend.application.dto.*
import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.comment.getByIdOrThrow
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.community.findByIdOrThrow
import com.dclass.backend.domain.notification.NotificationEvent
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.findByIdOrThrow
import com.dclass.backend.domain.reply.ReplyRepository
import com.dclass.backend.domain.reply.getByIdAndUserIdOrThrow
import com.dclass.backend.domain.reply.getByIdOrThrow
import org.springframework.context.ApplicationEventPublisher
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class ReplyService(
    private val replyRepository: ReplyRepository,
    private val replyValidator: ReplyValidator,
    private val eventPublisher: ApplicationEventPublisher,
    private val communityRepository: CommunityRepository,
    private val commentRepository: CommentRepository,
    private val postRepository: PostRepository
) {
    fun create(userId: Long, request: CreateReplyRequest): ReplyResponse {
        val comment = commentRepository.getByIdOrThrow(request.commentId)
        val post = postRepository.findByIdOrThrow(comment.postId)
        val community = communityRepository.findByIdOrThrow(post.communityId)

        replyValidator.validate(userId, community.departmentId)

        val reply = replyRepository.save(request.toEntity(userId))

        if (post.isEligibleForSSE(userId)) {
            val event = NotificationEvent.replyToPostUser(post, comment, reply, community)
            eventPublisher.publishEvent(event)
        }
        if (comment.isEligibleForSSE(userId)) {
            val event = NotificationEvent.replyToCommentUser(post, comment, reply, community)
            eventPublisher.publishEvent(event)
        }

        comment.increaseReplyCount()

        return ReplyResponse(reply)

    }

    fun update(userId: Long, request: UpdateReplyRequest) {
        val reply = replyRepository.getByIdAndUserIdOrThrow(request.replyId, userId)
        reply.changeContent(request.content)
    }

    fun delete(userId: Long, request: DeleteReplyRequest) {
        val reply = replyRepository.getByIdAndUserIdOrThrow(request.replyId, userId)

        val comment = commentRepository.getByIdOrThrow(reply.commentId)
        val post = postRepository.findByIdOrThrow(comment.postId)
        post.decreaseCommentReplyCount()
        comment.decreaseReplyCount()

        replyRepository.delete(reply)
    }

    fun like(userId: Long, request: LikeReplyRequest) {
        val reply = replyRepository.getByIdOrThrow(request.replyId)
        val comment = commentRepository.getByIdOrThrow(reply.commentId)
        val post = postRepository.findByIdOrThrow(comment.postId)
        val community = communityRepository.findByIdOrThrow(post.communityId)

        replyValidator.validate(userId, community.departmentId)
        reply.like(userId)
    }
}