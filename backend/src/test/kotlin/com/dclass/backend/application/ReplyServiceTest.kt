package com.dclass.backend.application

import com.dclass.backend.application.dto.CreateReplyRequest
import com.dclass.backend.domain.comment.Comment
import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.comment.getByIdOrThrow
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.reply.ReplyRepository
import com.dclass.backend.exception.comment.CommentException
import com.dclass.backend.exception.comment.CommentExceptionType
import io.kotest.assertions.throwables.shouldThrow
import io.kotest.core.spec.style.BehaviorSpec
import io.kotest.matchers.shouldBe
import io.mockk.every
import io.mockk.mockk
import org.springframework.context.ApplicationEventPublisher

class ReplyServiceTest : BehaviorSpec({

    val replyRepository = mockk<ReplyRepository>()
    val replyValidator = mockk<ReplyValidator>()
    val eventPublisher = mockk<ApplicationEventPublisher>()
    val communityRepository = mockk<CommunityRepository>()
    val commentRepository = mockk<CommentRepository>()
    val postRepository = mockk<PostRepository>()

    val replyService = ReplyService(
        replyRepository,
        replyValidator,
        eventPublisher,
        communityRepository,
        commentRepository,
        postRepository
    )

    Given("삭제된 댓글이 존재하는 경우") {
        val comment = mockk<Comment>()
        every { commentRepository.getByIdOrThrow(any()) } returns comment
        every { comment.isDeleted() } returns true

        When("답글을 달면") {
            Then("삭제된 댓글 예외가 발생한다") {
                shouldThrow<CommentException> {
                    replyService.create(1L, CreateReplyRequest(1L, "reply content"))
                }.exceptionType() shouldBe CommentExceptionType.DELETED_COMMENT
            }
        }
    }
})
