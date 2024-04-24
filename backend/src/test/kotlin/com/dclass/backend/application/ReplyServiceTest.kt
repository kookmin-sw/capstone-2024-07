package com.dclass.backend.application

import com.dclass.backend.application.dto.CreateReplyRequest
import com.dclass.backend.application.dto.DeleteReplyRequest
import com.dclass.backend.application.dto.LikeReplyRequest
import com.dclass.backend.application.dto.UpdateReplyRequest
import com.dclass.backend.domain.comment.Comment
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
import com.dclass.backend.exception.comment.CommentException
import com.dclass.backend.exception.comment.CommentExceptionType
import com.dclass.backend.exception.reply.ReplyException
import com.dclass.backend.exception.reply.ReplyExceptionType
import com.dclass.support.fixtures.comment
import com.dclass.support.fixtures.community
import com.dclass.support.fixtures.post
import com.dclass.support.fixtures.reply
import io.kotest.assertions.throwables.shouldThrow
import io.kotest.core.spec.style.BehaviorSpec
import io.kotest.matchers.ints.shouldBeLessThan
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

    Given("답글이 존재하는 경우") {
        val reply = reply()
        every { replyRepository.getByIdAndUserIdOrThrow(any(), any()) } returns reply

        When("답글을 수정하면") {
            replyService.update(1L, UpdateReplyRequest(1L, "updated content"))

            Then("내용이 변경된다") {
                reply.content shouldBe "updated content"
            }
        }
    }

    Given("답글이 존재하는 경우2") {
        val reply = reply()
        every { replyRepository.getByIdAndUserIdOrThrow(any(), any()) } returns reply

        val comment = comment()
        every { commentRepository.getByIdOrThrow(any()) } returns comment

        val post = post()
        every { postRepository.findByIdOrThrow(any()) } returns post

        justRun { replyRepository.delete(any()) }

        When("답글을 삭제하면") {
            replyService.delete(1L, DeleteReplyRequest(1L))

            Then("답글이 삭제된다") {
                verify { replyRepository.delete(reply) }
            }

            Then("댓글의 답글 수가 감소한다") {
                comment.replyCount shouldBeLessThan 0
            }

            Then("게시글의 댓글 답글 수가 감소한다") {
                post.postCount.commentReplyCount shouldBe 29
            }
        }
    }

    Given("답글이 존재하는 경우3") {
        val reply = reply()
        every { replyRepository.getByIdOrThrow(any()) } returns reply

        val comment = comment()
        every { commentRepository.getByIdOrThrow(any()) } returns comment

        val post = post()
        every { postRepository.findByIdOrThrow(any()) } returns post

        val community = community()
        every { communityRepository.findByIdOrThrow(any()) } returns community

        justRun { replyValidator.validate(any(), any()) }

        When("답글을 좋아요하면") {
            replyService.like(2L, LikeReplyRequest(1L))

            Then("답글의 좋아요 수가 증가한다") {
                reply.likeCount shouldBe 1
            }
        }
    }

    Given("답글이 존재하는 경우4") {
        val reply = reply()
        every { replyRepository.getByIdOrThrow(any()) } returns reply

        val comment = comment()
        every { commentRepository.getByIdOrThrow(any()) } returns comment

        val post = post()
        every { postRepository.findByIdOrThrow(any()) } returns post

        val community = community()
        every { communityRepository.findByIdOrThrow(any()) } returns community

        justRun { replyValidator.validate(any(), any()) }

        When("자기 답글에 좋아요하면") {
            Then("예외가 발생한다") {
                shouldThrow<ReplyException> {
                    replyService.like(1L, LikeReplyRequest(1L))
                }.exceptionType() shouldBe ReplyExceptionType.SELF_LIKE
            }
        }
    }
})
