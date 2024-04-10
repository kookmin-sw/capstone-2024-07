package com.dclass.backend.domain.comment

import com.dclass.backend.application.dto.CommentScrollPageRequest
import com.dclass.backend.application.dto.CommentWithUserResponse
import com.dclass.backend.domain.user.UniversityRepository
import com.dclass.backend.domain.user.UserRepository
import com.dclass.support.fixtures.comment
import com.dclass.support.fixtures.university
import com.dclass.support.fixtures.user
import com.dclass.support.test.RepositoryTest
import io.kotest.core.spec.style.BehaviorSpec
import io.kotest.extensions.spring.SpringTestExtension
import io.kotest.extensions.spring.SpringTestLifecycleMode
import io.kotest.matchers.collections.shouldContainExactly
import io.kotest.matchers.collections.shouldHaveSize

@RepositoryTest
class CommentRepositorySupportImplTest(
    private val userRepository: UserRepository,
    private val commentRepository: CommentRepository,
    private val universityRepository: UniversityRepository
) : BehaviorSpec({
    extensions(SpringTestExtension(SpringTestLifecycleMode.Root))

    Given("게시글에 두명의 사용자가 댓글을 작성할 때") {
        val uni = universityRepository.save(university())
        val user1 = userRepository.save(user(university = uni))
        val user2 = userRepository.save(user(university = uni))

        val comments1 = commentRepository.saveAll(
            listOf(
                comment(userId = user1.id, postId = 1L),
                comment(userId = user1.id, postId = 1L),
                comment(userId = user1.id, postId = 1L),
                comment(userId = user1.id, postId = 1L),
                comment(userId = user1.id, postId = 1L),
            )
        )

        val comments2 = commentRepository.saveAll(
            listOf(
                comment(userId = user2.id, postId = 1L),
                comment(userId = user2.id, postId = 1L),
                comment(userId = user2.id, postId = 1L),
                comment(userId = user2.id, postId = 1L),
                comment(userId = user2.id, postId = 1L),
            )
        )

        When("게시글에 해당하는 댓글을 조회하면") {
            val comments = commentRepository.findCommentWithUserByPostId(CommentScrollPageRequest(postId = 1L))

            Then("댓글 및 작성자 정보가 반환된다") {

                comments shouldHaveSize 10

                val expected = comments1.map {
                    CommentWithUserResponse(it, user1)
                } + comments2.map { CommentWithUserResponse(it, user2) }
                comments shouldContainExactly expected
            }
        }
    }
})