package com.dclass.backend.application

import com.dclass.backend.application.dto.CommentResponse
import com.dclass.backend.application.dto.CreateCommentRequest
import com.dclass.backend.application.dto.DeleteCommentRequest
import com.dclass.backend.application.dto.UpdateCommentRequest
import com.dclass.backend.domain.comment.Comment
import com.dclass.backend.domain.comment.CommentRepository
import jakarta.persistence.Id
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class CommentService (
    private val commentRepository: CommentRepository,
){
    fun create(userId: Long, request: CreateCommentRequest) : CommentResponse {
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


    private fun find(commentId: Long, userId: Long) : Comment {
        val comment = commentRepository.findCommentByIdAndUserId(commentId, userId)
            ?: throw NoSuchElementException("해당 댓글이 존재하지 않습니다.")
        check(!comment.isDeleted(commentId)){
            "삭제된 댓글입니다."
        }
        return comment
    }
}
