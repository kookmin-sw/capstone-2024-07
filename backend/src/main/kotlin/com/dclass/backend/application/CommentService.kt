package com.dclass.backend.application

import com.dclass.backend.application.dto.*
import com.dclass.backend.domain.comment.Comment
import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.reply.ReplyRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class CommentService(
    private val commentRepository: CommentRepository,
    private val replyRepository: ReplyRepository
) {
    fun create(userId: Long, request: CreateCommentRequest): CommentResponse {
        return commentRepository.save(Comment(userId, request.postId, request.content))
            .let(::CommentResponse)
    }

    fun update(userId: Long, request: UpdateCommentRequest) {
        val comment = find(request.commentId, userId)
        comment.changeContent(request.content)
    }

    fun delete(userId: Long, request: DeleteCommentRequest) {
        val comment = find(request.commentId, userId)
        commentRepository.delete(comment)
    }

    @Transactional(readOnly = true)
    fun findAllByPostId(postId: Long): List<CommentReplyWithUserResponse> {
        val comments = commentRepository.findCommentWithUserByPostId(postId)

        val commentIds = comments.map { it.id }

        val replies = replyRepository.findRepliesWithUserByCommentIdIn(commentIds)
            .groupBy { it.commentId }

        return comments.map {
            CommentReplyWithUserResponse(
                it,
                replies = replies[it.id] ?: emptyList()
            )
        }
    }

    private fun find(commentId: Long, userId: Long): Comment {
        val comment = commentRepository.findCommentByIdAndUserId(commentId, userId)
            ?: throw NoSuchElementException("해당 댓글이 존재하지 않습니다.")
        check(!comment.isDeleted(commentId)) {
            "삭제된 댓글입니다."
        }
        return comment
    }
}
