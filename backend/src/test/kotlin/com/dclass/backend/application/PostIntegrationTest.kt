package com.dclass.backend.application

import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.user.UniversityRepository
import com.dclass.backend.domain.user.UserRepository
import com.dclass.support.fixtures.*
import com.dclass.support.test.IntegrationTest
import io.kotest.assertions.throwables.shouldThrow
import io.kotest.core.spec.style.BehaviorSpec
import io.kotest.extensions.spring.SpringTestExtension
import io.kotest.extensions.spring.SpringTestLifecycleMode
import io.kotest.matchers.shouldBe
import io.kotest.matchers.throwable.shouldHaveMessage

const val NEVER_EXIST_ID: Long = 999_999

@IntegrationTest
class PostIntegrationTest(
    private val postService: PostService,
    private val userRepository: UserRepository,
    private val belongRepository: BelongRepository,
    private val universityRepository: UniversityRepository,
    private val communityRepository: CommunityRepository,
    private val postRepository: PostRepository,
) : BehaviorSpec({
    extensions(SpringTestExtension(SpringTestLifecycleMode.Root))

    Given("특정 학과에 속한 학생이 게시글을 작성한 경우") {
        val univ = universityRepository.save(university())
        val user = userRepository.save(user(university = univ))
        val community = communityRepository.save(community())
        val belong =
            belongRepository.save(belong(userId = user.id, departmentIds = listOf(community.id)))
        val post = postRepository.save(post(userId = user.id, communityId = community.id))

        When("게시글을 하나 조회하면") {
            val actual = postService.getById(user.id, post.id)

            Then("게시글이 조회된다") {
                actual.id shouldBe post.id
                actual.userNickname shouldBe user.nickname
                actual.universityName shouldBe user.universityName
                actual.communityTitle shouldBe community.title
            }
        }

        val anotherUser = userRepository.save(user(university = univ))
        val notBelong =
            belongRepository.save(
                belong(
                    userId = anotherUser.id,
                    departmentIds = listOf(NEVER_EXIST_ID)
                )
            )

        When("다른 학과에 속한 학생이 게시글을 조회하면") {
            Then("게시글이 조회되지 않는다") {
                shouldThrow<IllegalStateException> {
                    postService.getById(anotherUser.id, post.id)
                }.shouldHaveMessage("해당 커뮤니티의 게시글을 조회할 수 없습니다.")
            }
        }
    }
})