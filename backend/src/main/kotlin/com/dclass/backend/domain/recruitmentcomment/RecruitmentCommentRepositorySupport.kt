package com.dclass.backend.domain.recruitmentcomment

import com.dclass.backend.application.dto.RecruitmentCommentScrollRequest
import com.dclass.backend.application.dto.RecruitmentCommentWithUserResponse
import com.dclass.backend.domain.recruitmentreply.RecruitmentReply
import com.dclass.backend.domain.user.User
import com.linecorp.kotlinjdsl.dsl.jpql.jpql
import com.linecorp.kotlinjdsl.render.jpql.JpqlRenderContext
import com.linecorp.kotlinjdsl.support.spring.data.jpa.extension.createQuery
import jakarta.persistence.EntityManager

interface RecruitmentCommentRepositorySupport {
    fun findRecruitmentCommentWithUserByRecruitmentId(
        request: RecruitmentCommentScrollRequest,
    ): List<RecruitmentCommentWithUserResponse>
    fun countRecruitmentCommentReplyByRecruitmentId(recruitmentId: Long): Long
}

class RecruitmentCommentRepositoryImpl(
    private val em: EntityManager,
    private val context: JpqlRenderContext,
) : RecruitmentCommentRepositorySupport {
    override fun findRecruitmentCommentWithUserByRecruitmentId(
        request: RecruitmentCommentScrollRequest,
    ): List<RecruitmentCommentWithUserResponse> {
        val query = jpql {
            selectNew<RecruitmentCommentWithUserResponse>(
                entity(RecruitmentComment::class),
                entity(User::class),
            ).from(
                entity(RecruitmentComment::class),
                join(User::class).on(path(RecruitmentComment::userId).eq(path(User::id))),
            ).whereAnd(
                path(RecruitmentComment::recruitmentId).eq(request.recruitmentId),
                path(RecruitmentComment::id).greaterThan(request.lastCommentId ?: Long.MIN_VALUE),
            ).orderBy(
                path(RecruitmentComment::id).asc(),
            )
        }

        return em.createQuery(query, context).setMaxResults(request.size).resultList
    }

    override fun countRecruitmentCommentReplyByRecruitmentId(recruitmentId: Long): Long {
        val query = jpql {
            val replyCount = expression(Long::class, "cnt")

            val subquery = select(
                count(entity(RecruitmentComment::class)),
            ).from(
                entity(RecruitmentComment::class),
                join(
                    RecruitmentReply::class,
                ).on(path(RecruitmentComment::id).eq(path(RecruitmentReply::recruitmentCommentId))),
            ).where(
                path(RecruitmentComment::recruitmentId).eq(recruitmentId),
            ).asSubquery().`as`(replyCount)

            select(
                count(path(RecruitmentComment::id)).plus(subquery),
            ).from(
                entity(RecruitmentComment::class),
            ).where(
                path(RecruitmentComment::recruitmentId).eq(recruitmentId),
            )
        }

        return em.createQuery(query, context).singleResult
    }
}
