package com.dclass.backend.application

import com.dclass.backend.application.dto.CommentResponse
import com.dclass.backend.application.dto.CreateCommentRequest
import com.dclass.backend.application.dto.DeleteCommentRequest
import com.dclass.backend.application.dto.UpdateCommentRequest
import com.dclass.backend.domain.comment.Comment
import com.dclass.backend.domain.comment.CommentRepository
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
        val comment = findByCommentId(request.commentId)
        if(userId != comment.userId) throw NoSuchElementException("다른 유저의 댓글입니다.")
        comment.changeContent(request.content)
    }

    fun delete(userId: Long, request: DeleteCommentRequest) {
        val comment = findByCommentId(request.commentId)
        if(userId != comment.userId) throw NoSuchElementException("다른 유저의 댓글입니다.")
        commentRepository.delete(comment)
    }

    private fun findByCommentId(commentId: Long) : Comment {
        val comment = commentRepository.findCommentById(commentId)
            ?: throw NoSuchElementException("해당 댓글이 존재하지 않습니다.")
        check(!comment.isDeleted(commentId)){
            "삭제된 댓글입니다."
        }
        return comment
    }
}
