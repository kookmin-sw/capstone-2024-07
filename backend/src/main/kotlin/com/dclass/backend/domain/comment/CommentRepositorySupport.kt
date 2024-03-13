package com.dclass.backend.domain.comment

import com.dclass.backend.application.dto.CommentWithUserResponse
import com.dclass.backend.domain.reply.Reply
import com.dclass.backend.domain.user.User
import com.linecorp.kotlinjdsl.dsl.jpql.jpql
import com.linecorp.kotlinjdsl.render.jpql.JpqlRenderContext
import com.linecorp.kotlinjdsl.support.spring.data.jpa.extension.createQuery
import jakarta.persistence.EntityManager

interface CommentRepositorySupport {
    fun findCommentWithUserByPostId(postId: Long): List<CommentWithUserResponse>
    fun countCommentReplyByPostId(postId: Long): Long
}

class CommentRepositoryImpl(
    private val em: EntityManager,
    private val context: JpqlRenderContext
) : CommentRepositorySupport {

    override fun findCommentWithUserByPostId(postId: Long): List<CommentWithUserResponse> {
        val query = jpql {
            selectNew<CommentWithUserResponse>(
                entity(Comment::class),
                entity(User::class),
            ).from(
                entity(Comment::class),
                join(User::class).on(path(Comment::userId).eq(path(User::id))),
            ).where(
                path(Comment::postId).eq(postId)
            )
        }

        return em.createQuery(query, context).resultList
    }

    override fun countCommentReplyByPostId(postId: Long): Long {
        val query = jpql {
            val replyCount = expression(Long::class, "cnt")

            val subquery = select(
                count(entity(Reply::class))
            ).from(
                entity(Comment::class),
                join(Reply::class).on(path(Comment::id).eq(path(Reply::commentId)))
            ).where(
                path(Comment::postId).eq(postId)
            ).asSubquery().`as`(replyCount)

            select(
                count(path(Comment::id)).plus(subquery)
            ).from(
                entity(Comment::class)
            ).where(
                path(Comment::postId).eq(postId)
            )
        }

        return em.createQuery(query, context).singleResult
    }
}