package com.dclass.backend.domain.post

import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.user.UniversityRepository
import com.dclass.backend.domain.user.UserRepository
import com.dclass.support.fixtures.community
import com.dclass.support.fixtures.post
import com.dclass.support.fixtures.university
import com.dclass.support.fixtures.user
import com.dclass.support.test.RepositoryTest
import io.kotest.core.spec.style.BehaviorSpec
import io.kotest.extensions.spring.SpringTestExtension
import io.kotest.extensions.spring.SpringTestLifecycleMode
import io.kotest.matchers.shouldBe

@RepositoryTest
class PostRepositorySupportTest(
    private val userRepository: UserRepository,
    private val postRepository: PostRepository,
    private val communityRepository: CommunityRepository,
    private val universityRepository: UniversityRepository
) : BehaviorSpec({
    extensions(SpringTestExtension(SpringTestLifecycleMode.Root))

    Given("게시글이 작성되어있는 경우") {
        val univ = universityRepository.save(university())
        val user = userRepository.save(user(university = univ))
        val community = communityRepository.save(community())
        val post = postRepository.save(post(userId = user.id, communityId = community.id))

        When("게시글을 조회하면") {
            val actual = postRepository.findPostById(post.id)

            Then("사용자 정보 및 커뮤니티 정보를 포함한 게시글이 반환된다") {
                actual.id shouldBe post.id
                actual.userNickname shouldBe user.nickname
                actual.universityName shouldBe user.universityName
                actual.communityTitle shouldBe community.title
            }
        }
    }
})
