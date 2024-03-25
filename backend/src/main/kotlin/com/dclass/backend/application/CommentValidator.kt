package com.dclass.backend.application

import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.comment.getByIdOrThrow
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.community.getByIdOrThrow
import com.dclass.backend.domain.post.Post
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.getByIdOrThrow
import com.dclass.backend.exception.comment.CommentException
import com.dclass.backend.exception.comment.CommentExceptionType.FORBIDDEN_COMMENT
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class CommentValidator(
    private val postRepository: PostRepository,
    private val belongRepository: BelongRepository,
    private val communityRepository: CommunityRepository,
    private val commentRepository: CommentRepository,
) {
    fun validateCreateComment(userId: Long, postId: Long): Post {
        return validateCommon(userId, postId)
    }

    fun validateLikeComment(userId: Long, commentId: Long) {
        val comment = commentRepository.getByIdOrThrow(commentId)
        validateCommon(userId, comment.postId)

    }

    private fun validateCommon(userId: Long, postId: Long): Post {
        val belong = belongRepository.getOrThrow(userId)
        val post = postRepository.getByIdOrThrow(postId)
        val community =
            communityRepository.getByIdOrThrow(post.communityId)
        if (!belong.contain(community.departmentId)) {
            throw CommentException(FORBIDDEN_COMMENT)
        }

        return post
    }
}