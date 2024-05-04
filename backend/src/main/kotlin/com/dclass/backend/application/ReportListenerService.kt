package com.dclass.backend.application

import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.comment.getByIdOrThrow
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.findByIdOrThrow
import com.dclass.backend.domain.reply.ReplyRepository
import com.dclass.backend.domain.reply.getByIdOrThrow
import com.dclass.backend.domain.report.CommentReportedEvent
import com.dclass.backend.domain.report.PostReportedEvent
import com.dclass.backend.domain.report.ReplyReportedEvent
import org.springframework.transaction.annotation.Transactional
import org.springframework.transaction.event.TransactionalEventListener
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Propagation


@Service
@Transactional
class ReportListenerService(
    private val postRepository: PostRepository,
    private val commentRepository: CommentRepository,
    private val replyRepository: ReplyRepository
) {

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @TransactionalEventListener
    fun delete(event: PostReportedEvent){
        val post = postRepository.findByIdOrThrow(event.postId)
        postRepository.delete(post)
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @TransactionalEventListener
    fun delete(event: CommentReportedEvent){
        val comment = commentRepository.getByIdOrThrow(event.commentId)
        val post = postRepository.findByIdOrThrow(comment.postId)
        post.decreaseCommentReplyCount()
        commentRepository.delete(comment)

    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @TransactionalEventListener
    fun delete(event: ReplyReportedEvent){
        val reply = replyRepository.getByIdOrThrow(event.replyId)
        val comment = commentRepository.getByIdOrThrow(reply.commentId)
        val post = postRepository.findByIdOrThrow(comment.postId)
        post.decreaseCommentReplyCount()
        replyRepository.delete(reply)
    }
}