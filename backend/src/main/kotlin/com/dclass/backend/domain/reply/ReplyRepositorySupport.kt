package com.dclass.backend.domain.reply

import com.dclass.backend.application.dto.ReplyWithUserResponse
import com.dclass.backend.domain.user.User
import com.linecorp.kotlinjdsl.dsl.jpql.Jpql
import com.linecorp.kotlinjdsl.dsl.jpql.jpql
import com.linecorp.kotlinjdsl.querymodel.jpql.predicate.Predicatable
import com.linecorp.kotlinjdsl.render.jpql.JpqlRenderContext
import com.linecorp.kotlinjdsl.support.spring.data.jpa.extension.createQuery
import jakarta.persistence.EntityManager

interface ReplyRepositorySupport {
    fun findRepliesWithUserByCommentIdIn(commentIds: List<Long>): List<ReplyWithUserResponse>
}

class ReplyRepositoryImpl(
    private val em: EntityManager,
    private val context: JpqlRenderContext
) : ReplyRepositorySupport {

    override fun findRepliesWithUserByCommentIdIn(commentIds: List<Long>): List<ReplyWithUserResponse> {
        val query = jpql {
            selectNew<ReplyWithUserResponse>(
                entity(Reply::class),
                entity(User::class)
            ).from(
                entity(Reply::class),
                join(User::class).on(path(Reply::userId).eq(path(User::id)))
            ).where(
                replyExist(commentIds)
            )
        }

        return em.createQuery(query, context).resultList
    }

    private fun Jpql.replyExist(request: List<Long>): Predicatable? {
        return if (request.isNotEmpty()) path(Reply::commentId).`in`(request) else null
    }
}