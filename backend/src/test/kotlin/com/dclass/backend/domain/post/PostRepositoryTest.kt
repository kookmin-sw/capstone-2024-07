package com.dclass.backend.domain.post

import com.dclass.backend.application.dto.PostScrollPageRequest
import com.dclass.support.fixtures.post
import com.dclass.support.test.RepositoryTest
import io.kotest.core.spec.style.ExpectSpec
import io.kotest.extensions.spring.SpringTestExtension
import io.kotest.extensions.spring.SpringTestLifecycleMode
import io.kotest.matchers.longs.shouldBeGreaterThan
import io.kotest.matchers.shouldBe

@RepositoryTest
class PostRepositoryTest(
    private val postRepository: PostRepository
) : ExpectSpec({
    extensions(SpringTestExtension(SpringTestLifecycleMode.Root))

    context("게시글 조회") {
        repeat(20) {
            postRepository.save(post(title = "title $it", content = "content $it"))
        }

        expect("lastId가 없으면 최신 게시글부터 조회한다") {
            val postScrollPageRequest = PostScrollPageRequest(
                lastId = null,
                communityTitle = null,
                size = 10,
            )
            val test = postRepository.findAll()
            val actual = postRepository.findPostScrollPage(postScrollPageRequest)
            print(test)
            actual.size shouldBe 10
            actual.first().id shouldBeGreaterThan actual.last().id
        }

        val lastId = postRepository.findAll().last().id

        expect("lastId가 있으면 lastId보다 작은 게시글부터 조회한다") {
            val postScrollPageRequest = PostScrollPageRequest(
                lastId = lastId,
                communityTitle = null,
                size = 10,
            )
            val actual = postRepository.findPostScrollPage(postScrollPageRequest)

            actual.size shouldBe 10
            actual.first().id shouldBeGreaterThan actual.last().id
        }
    }
})