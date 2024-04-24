package com.dclass.backend.application

import com.dclass.backend.application.dto.CreateReplyRequest
import com.dclass.backend.domain.comment.Comment
import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.comment.getByIdOrThrow
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.community.findByIdOrThrow
import com.dclass.backend.domain.notification.NotificationEvent
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.findByIdOrThrow
import com.dclass.backend.domain.reply.ReplyRepository
import com.dclass.backend.exception.comment.CommentException
import com.dclass.backend.exception.comment.CommentExceptionType
import com.dclass.support.fixtures.comment
import com.dclass.support.fixtures.community
import com.dclass.support.fixtures.post
import com.dclass.support.fixtures.reply
import io.kotest.assertions.throwables.shouldThrow
import io.kotest.core.spec.style.BehaviorSpec
import io.kotest.matchers.shouldBe
import io.mockk.*
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

    Given("댓글이 존재하는 경우") {
        val comment = comment()
        every { commentRepository.getByIdOrThrow(any()) } returns comment

        val post = post()
        every { postRepository.findByIdOrThrow(any()) } returns post
        val community = community()
        every { communityRepository.findByIdOrThrow(any()) } returns community

        justRun { replyValidator.validate(any(), any()) }

        val reply = reply()
        every { replyRepository.save(any()) } returns reply

        mockkObject(NotificationEvent.Companion) {
            every { NotificationEvent.replyToPostUser(any(), any(), any(), any()) } returns mockk()
            every {
                NotificationEvent.replyToCommentUser(
                    any(),
                    any(),
                    any(),
                    any()
                )
            } returns mockk()
        }

        justRun { eventPublisher.publishEvent(any<NotificationEvent>()) }

        When("다른 사람이 답글을 달면") {
            replyService.create(2L, CreateReplyRequest(1L, "reply content"))

            Then("답글이 생성된다") {
                verify { replyRepository.save(any()) }
            }

            Then("댓글의 답글 수가 증가한다") {
                comment.replyCount shouldBe 1
            }

            Then("답글 알림을 발송한다") {
                verify { eventPublisher.publishEvent(any<NotificationEvent>()) }
            }
        }
    }
})
