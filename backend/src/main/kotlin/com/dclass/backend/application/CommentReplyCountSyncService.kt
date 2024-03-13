package com.dclass.backend.application

import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.post.PostRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.transaction.annotation.Transactional

@Transactional
class CommentReplyCountSyncService(
    private val commentRepository: CommentRepository,
    private val postRepository: PostRepository
) {
    fun sync(postId: Long) {
        val count = commentRepository.countCommentReplyByPostId(postId)
        val post = postRepository.findByIdOrNull(postId)
        post?.let { it.increaseCommentReplyCount(count.toInt()) }
    }
}