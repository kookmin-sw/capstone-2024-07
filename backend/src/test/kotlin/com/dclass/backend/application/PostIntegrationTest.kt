package com.dclass.backend.application

import com.dclass.backend.application.dto.PostScrollPageRequest
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.post.PostCount
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.scrap.ScrapRepository
import com.dclass.backend.domain.user.UniversityRepository
import com.dclass.backend.domain.user.UserRepository
import com.dclass.backend.exception.post.PostException
import com.dclass.backend.exception.post.PostExceptionType
import com.dclass.support.fixtures.*
import com.dclass.support.test.IntegrationTest
import io.kotest.assertions.throwables.shouldThrow
import io.kotest.core.spec.style.BehaviorSpec
import io.kotest.extensions.spring.SpringTestExtension
import io.kotest.extensions.spring.SpringTestLifecycleMode
import io.kotest.matchers.shouldBe
import org.springframework.transaction.annotation.Transactional

const val NEVER_EXIST_ID: Long = 999_999

@IntegrationTest
@Transactional
class PostIntegrationTest(
    private val postService: PostService,
    private val userRepository: UserRepository,
    private val belongRepository: BelongRepository,
    private val universityRepository: UniversityRepository,
    private val communityRepository: CommunityRepository,
    private val postRepository: PostRepository,
    private val scrapRepository: ScrapRepository,
    private val commentRepository: CommentRepository,
) : BehaviorSpec({
    extensions(SpringTestExtension(SpringTestLifecycleMode.Root))

    Given("특정 학과에 속한 학생이 게시글을 작성한 경우") {
        val univ = universityRepository.save(university())
        val user = userRepository.save(user(university = univ))
        val community = communityRepository.save(community())
        val belong =
            belongRepository.save(
                belong(
                    userId = user.id,
                    departmentIds = listOf(community.departmentId)
                )
            )
        val post = postRepository.save(post(userId = user.id, communityId = community.id))

        When("게시글을 하나 조회하면") {
            val actual = postService.getById(user.id, post.id)

            Then("게시글이 조회된다") {
                actual.id shouldBe post.id
                actual.userNickname shouldBe user.nickname
                actual.universityName shouldBe user.universityName
                actual.communityTitle shouldBe community.title
            }
            /**
             * 테스트마다 비용이 부과되어 주석처리
             */
            Then("이미지가 조회된다") {
                //actual.images.forEach { it shouldStartWith "https://dclass" }
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
                shouldThrow<PostException> {
                    postService.getById(anotherUser.id, post.id)
                }.exceptionType() shouldBe PostExceptionType.FORBIDDEN_POST
            }
        }
    }

    Given("특정 학과에 속한 학생이 게시글을 조회하는 경우") {
        val univ = universityRepository.save(university())
        val user = userRepository.save(user(university = univ))

        val communities = communityRepository.saveAll(
            listOf(
                community(departmentId = 1L, title = "FREE"),
                community(departmentId = 1L, title = "GRADUATE"),
                community(departmentId = 1L, title = "JOB"),
            )
        )
        belongRepository.save(
            belong(
                userId = user.id,
                departmentIds = communities.map { it.departmentId }.distinct()
            )
        )

        repeat(5) {
            postRepository.save(
                post(
                    userId = user.id,
                    communityId = communities[0].id,
                    postCount = PostCount()
                )
            )
            postRepository.save(
                post(
                    userId = user.id,
                    communityId = communities[1].id,
                    postCount = PostCount()
                )
            )
            postRepository.save(
                post(
                    userId = user.id,
                    communityId = communities[2].id,
                    postCount = PostCount()
                )
            )
            postRepository.save(post(title = "검색용 제목", content = "내용입니다", userId = user.id, communityId = communities[2].id))
        }

        val anotherUser = userRepository.save(user(university = univ))

        val notMyCommunities = communityRepository.saveAll(
            listOf(
                community(departmentId = 2L, title = "다른 자유"),
                community(departmentId = 2L, title = "다른 대학원"),
                community(departmentId = 2L, title = "다른 취업"),
            )
        )

        repeat(5) {
            postRepository.save(
                post(
                    userId = anotherUser.id,
                    communityId = notMyCommunities[0].id,
                    postCount = PostCount()
                )
            )
            postRepository.save(
                post(
                    userId = anotherUser.id,
                    communityId = notMyCommunities[1].id,
                    postCount = PostCount()
                )
            )
            postRepository.save(
                post(
                    userId = anotherUser.id,
                    communityId = notMyCommunities[2].id,
                    postCount = PostCount()
                )
            )
            postRepository.save(post(title = "검색용 제목", content = "내용입니다", userId = anotherUser.id, communityId = notMyCommunities[2].id))
        }

        When("모든 게시글을 조회하면") {
            val actual =
                postService.getAll(user.id, PostScrollPageRequest(size = 30, isHot = false))

            Then("자신이 속한 학과 커뮤니티의 모든 게시글이 조회된다") {
                actual.meta.count shouldBe 30
            }
        }

        When("특정 유저가 작성한 게시글을 조회하면") {
            val actual = postService.getByUserId(user.id, PostScrollPageRequest(size = 30))

            Then("특정 유저가 작성한 게시글이 조회된다") {
                actual.meta.count shouldBe 20
            }
        }

        When("특정 유저가 특정 게시글을 스크랩하면") {
            repeat(5) {
                scrapRepository.save(scrap(userId = user.id, postId = it + 1L))
            }

            val actual = postService.getScrapped(user.id, PostScrollPageRequest(size = 30))

            Then("특정 유저가 스크랩한 게시글이 조회된다") {
                actual.meta.count shouldBe 5
            }
        }

        When("특정 유저가 특정 게시글에 댓글을 작성하면") {
            repeat(5) {
                commentRepository.save(comment(userId = user.id, postId = it + 1L))
            }

            val actual = postService.getCommentedAndReplied(user.id, PostScrollPageRequest(size = 30))

            Then("특정 유저가 댓글을 작성한 게시글이 조회된다") {
                actual.meta.count shouldBe 5
            }
        }
    }
})