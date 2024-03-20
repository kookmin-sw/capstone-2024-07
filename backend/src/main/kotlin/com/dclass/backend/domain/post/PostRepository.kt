package com.dclass.backend.domain.post

import com.dclass.backend.application.dto.PostResponse
import com.dclass.backend.application.dto.PostScrollPageRequest
import com.dclass.backend.domain.community.Community
import com.dclass.backend.domain.user.User
import com.dclass.backend.exception.post.PostException
import com.dclass.backend.exception.post.PostExceptionType.NOT_FOUND_POST
import com.linecorp.kotlinjdsl.dsl.jpql.Jpql
import com.linecorp.kotlinjdsl.dsl.jpql.jpql
import com.linecorp.kotlinjdsl.querymodel.jpql.predicate.Predicatable
import com.linecorp.kotlinjdsl.render.jpql.JpqlRenderContext
import com.linecorp.kotlinjdsl.support.spring.data.jpa.extension.createQuery
import jakarta.persistence.EntityManager
import org.springframework.data.jpa.repository.JpaRepository

fun PostRepository.getByIdOrThrow(id: Long): Post = findById(id).orElseThrow {
    PostException(NOT_FOUND_POST)
}

interface PostRepository : JpaRepository<Post, Long>, PostRepositorySupport {
}

interface PostRepositorySupport {
    fun findPostScrollPage(request: PostScrollPageRequest): List<Post>
    fun findPostById(id: Long): PostResponse
    fun findPostScrollPage(
        communityIds: List<Long>,
        request: PostScrollPageRequest
    ): List<PostResponse>
}

private class PostRepositoryImpl(
    private val em: EntityManager,
    private val context: JpqlRenderContext
) : PostRepositorySupport {
    override fun findPostScrollPage(
        request: PostScrollPageRequest
    ): List<Post> {
        val query = jpql {
            select(
                entity(Post::class)
            ).from(
                entity(Post::class)
            ).where(
                path(Post::id).lessThan(request.lastId ?: Long.MAX_VALUE)
            ).orderBy(
                path(Post::id).desc()
            )
        }

        return em.createQuery(query, context).setMaxResults(request.size).resultList
    }

    override fun findPostById(id: Long): PostResponse {
        val query = jpql {
            selectNew<PostResponse>(
                entity(Post::class),
                entity(User::class),
                path(Community::title)
            ).from(
                entity(Post::class),
                join(User::class).on(path(Post::userId).equal(path(User::id))),
                join(Community::class).on(path(Post::communityId).equal(path(Community::id)))
            ).where(
                path(Post::id).equal(id)
            )
        }

        return em.createQuery(query, context).singleResult
    }

    override fun findPostScrollPage(
        communityIds: List<Long>,
        request: PostScrollPageRequest
    ): List<PostResponse> {

        val query = jpql {
            selectNew<PostResponse>(
                entity(Post::class),
                entity(User::class),
                path(Community::title)
            ).from(
                entity(Post::class),
                join(Community::class).on(path(Post::communityId).equal(path(Community::id))),
                join(User::class).on(path(Post::userId).equal(path(User::id)))
            ).whereAnd(
                path(Post::id).lessThan(request.lastId ?: Long.MAX_VALUE),
                path(Post::communityId).`in`(communityIds),
                request.communityTitle?.let { path(Community::title).equal(it) },
                isHot(request),
                isSearch(request)
            ).orderBy(
                path(Post::id).desc()
            )
        }
        return em.createQuery(query, context).setMaxResults(request.size).resultList
    }

    private fun Jpql.isSearch(request: PostScrollPageRequest): Predicatable? {
        return if (request.keyword != null) or(
            path(Post::title).like("%${request.keyword}%"),
            path(Post::content).like("%${request.keyword}%")
        ) else null
    }

    private fun Jpql.isHot(request: PostScrollPageRequest): Predicatable? {
        return if (request.isHot) path(Post::postCount)(PostCount::likeCount).ge(10) else null
    }
}