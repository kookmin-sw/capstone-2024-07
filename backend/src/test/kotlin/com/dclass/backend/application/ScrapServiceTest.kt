package com.dclass.backend.application

import com.dclass.backend.application.dto.PostResponse
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.findByIdOrThrow
import com.dclass.backend.domain.scrap.ScrapRepository
import com.dclass.backend.exception.scrap.ScrapException
import com.dclass.backend.exception.scrap.ScrapExceptionType
import com.dclass.support.fixtures.post
import com.dclass.support.fixtures.scrap
import com.dclass.support.fixtures.user
import io.kotest.assertions.throwables.shouldThrow
import io.kotest.core.spec.style.BehaviorSpec
import io.kotest.matchers.ints.shouldBeLessThan
import io.kotest.matchers.shouldBe
import io.mockk.every
import io.mockk.justRun
import io.mockk.mockk
import io.mockk.verify

class ScrapServiceTest : BehaviorSpec({

    val scrapRepository = mockk<ScrapRepository>()
    val postRepository = mockk<PostRepository>()
    val validator = mockk<ScrapValidator>()

    val scrapService = ScrapService(scrapRepository, postRepository, validator)

    Given("특정 사용자가") {
        val post = post()

        every { validator.validateScrapPost(any(), any()) } returns post
        every { scrapRepository.save(any()) } returns scrap()

        When("스크랩을 생성하면") {
            scrapService.create(1L, 1L)

            Then("save 메서드가 호출된다") {
                verify(exactly = 1) { scrapRepository.save(scrap()) }
            }

            Then("스크랩 갯수가 증가한다") {
                post.postCount.scrapCount shouldBe 1
            }
        }
    }

    Given("특정 사용자가 게시글을 스크랩을 안했을 경우") {
        val scrap = scrap()

        every { scrapRepository.findByUserIdAndPostId(any(), any()) } throws ScrapException(
            ScrapExceptionType.NOT_FOUND_SCRAP
        )

        When("스크랩을 삭제하면") {
            Then("예외가 발생한다") {
                shouldThrow<ScrapException> {
                    scrapService.delete(1L, 1L)
                }.exceptionType() shouldBe ScrapExceptionType.NOT_FOUND_SCRAP
            }
        }
    }

    Given("특정 사용자가 게시글을 스크랩을 했을 경우") {
        val scrap = scrap()
        val post =  post()

        every { scrapRepository.findByUserIdAndPostId(any(), any()) } returns scrap
        every { postRepository.findByIdOrThrow(any()) } returns post
        justRun { scrapRepository.delete(scrap) }

        When("스크랩을 삭제하면") {
            scrapService.delete(1L, 1L)

            Then("delete 메서드가 호출된다") {
                verify(exactly = 1) { scrapRepository.delete(scrap) }
            }

            Then("스크랩 갯수가 감소한다") {
                post.postCount.scrapCount shouldBeLessThan  0
            }
        }
    }

    Given("특정 사용자가 스크랩한 게시글을 조회하면") {
        every { postRepository.findScrapPostByUserId(any()) } returns listOf(PostResponse(post(),user(),"FREE"))

        When("스크랩한 게시글을 조회하면") {
            val actual = scrapService.getAll(1L)

            Then("스크랩한 게시글이 조회된다") {
                actual.size shouldBe 1
            }
        }
    }
})
