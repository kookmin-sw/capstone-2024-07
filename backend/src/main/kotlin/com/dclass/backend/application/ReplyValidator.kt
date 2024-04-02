package com.dclass.backend.application

import com.dclass.backend.application.dto.ReplyValidatorDto
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.comment.getByIdOrThrow
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.community.getByIdOrThrow
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.getByIdOrThrow
import com.dclass.backend.domain.reply.ReplyRepository
import com.dclass.backend.domain.reply.getByIdOrThrow
import com.dclass.backend.exception.reply.ReplyException
import com.dclass.backend.exception.reply.ReplyExceptionType
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class ReplyValidator(
    private val postRepository: PostRepository,
    private val belongRepository: BelongRepository,
    private val communityRepository: CommunityRepository,
    private val commentRepository: CommentRepository,
    private val replyRepository: ReplyRepository,
) {
    fun validateCreateReply(userId: Long, commentId: Long): ReplyValidatorDto {
        return validateCommon(userId, commentId)
    }

    fun validateLikeReply(userId: Long, replyId: Long) {
        val reply = replyRepository.getByIdOrThrow(replyId)
        validateCommon(userId, reply.commentId)
    }

    private fun validateCommon(userId: Long, commentId: Long): ReplyValidatorDto {
        val belong = belongRepository.getOrThrow(userId)
        val comment = commentRepository.getByIdOrThrow(commentId)
        val post = postRepository.getByIdOrThrow(comment.postId)
        val community =
            communityRepository.getByIdOrThrow(post.communityId)
        if (!belong.contain(community.departmentId)) {
            throw ReplyException(ReplyExceptionType.FORBIDDEN_REPLY)
        }

        return ReplyValidatorDto(post.id, comment.userId, community.title)
    }
}