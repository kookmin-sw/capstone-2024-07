package com.dclass.backend.domain.recruitmentreply

import com.dclass.backend.application.dto.RecruitmentReplyWithUserResponse
import com.dclass.backend.domain.user.User
import com.linecorp.kotlinjdsl.dsl.jpql.Jpql
import com.linecorp.kotlinjdsl.dsl.jpql.jpql
import com.linecorp.kotlinjdsl.querymodel.jpql.predicate.Predicatable
import com.linecorp.kotlinjdsl.render.jpql.JpqlRenderContext
import com.linecorp.kotlinjdsl.support.spring.data.jpa.extension.createQuery
import jakarta.persistence.EntityManager

interface RecruitmentReplyRepositorySupport {
    fun findRecruitmentRepliesWithUserByCommentIdIn(commentIds: List<Long>): List<RecruitmentReplyWithUserResponse>
}

class RecruitmentReplyRepositoryImpl(
    private val em: EntityManager,
    private val context: JpqlRenderContext,
) : RecruitmentReplyRepositorySupport {
    override fun findRecruitmentRepliesWithUserByCommentIdIn(
        commentIds: List<Long>,
    ): List<RecruitmentReplyWithUserResponse> {
        val query = jpql {
            selectNew<RecruitmentReplyWithUserResponse>(
                entity(RecruitmentReply::class),
                entity(User::class),
            ).from(
                entity(RecruitmentReply::class),
                join(User::class).on(path(RecruitmentReply::userId).eq(path(User::id))),
            ).where(
                replyExist(commentIds),
            )
        }

        return em.createQuery(query, context).resultList
    }

    private fun Jpql.replyExist(request: List<Long>): Predicatable? {
        return if (request.isNotEmpty()) path(RecruitmentReply::recruitmentCommentId).`in`(request) else null
    }
}
