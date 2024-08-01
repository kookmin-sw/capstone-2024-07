package com.dclass.backend.domain.recruitment

import com.dclass.backend.application.dto.RecruitmentScrollPageRequest
import com.dclass.backend.application.dto.RecruitmentWithUserResponse
import com.dclass.backend.domain.recruitmentscrap.RecruitmentScrap
import com.dclass.backend.domain.user.User
import com.linecorp.kotlinjdsl.dsl.jpql.Jpql
import com.linecorp.kotlinjdsl.dsl.jpql.jpql
import com.linecorp.kotlinjdsl.querymodel.jpql.predicate.Predicatable
import com.linecorp.kotlinjdsl.render.jpql.JpqlRenderContext
import com.linecorp.kotlinjdsl.support.spring.data.jpa.extension.createQuery
import jakarta.persistence.EntityManager

interface RecruitmentRepositorySupport {
    fun findRecruitmentScrollPage(
        departmentId: Long,
        request: RecruitmentScrollPageRequest,
    ): List<RecruitmentWithUserResponse>

    fun findRecruitmentScrollPageByUserId(
        userId: Long,
        request: RecruitmentScrollPageRequest,
    ): List<RecruitmentWithUserResponse>

    fun findScrappedRecruitmentByUserId(userId: Long): List<RecruitmentWithUserResponse>

    fun findRecruitmentById(id: Long): RecruitmentWithUserResponse
}

class RecruitmentRepositoryImpl(
    private val em: EntityManager,
    private val context: JpqlRenderContext,
) : RecruitmentRepositorySupport {
    override fun findRecruitmentScrollPage(
        departmentId: Long,
        request: RecruitmentScrollPageRequest,
    ): List<RecruitmentWithUserResponse> {
        val query = jpql {
            selectNew<RecruitmentWithUserResponse>(
                entity(Recruitment::class),
                entity(User::class),
            ).from(
                entity(Recruitment::class),
                join(User::class).on(path(Recruitment::userId).equal(path(User::id))),
            ).whereAnd(
                path(Recruitment::id).lessThan(request.lastId ?: Long.MAX_VALUE),
                path(Recruitment::departmentId).equal(departmentId),
                searchOption(request),
            ).orderBy(
                path(Recruitment::id).desc(),
            )
        }

        return em.createQuery(query, context).setMaxResults(request.size).resultList
    }

    override fun findScrappedRecruitmentByUserId(userId: Long): List<RecruitmentWithUserResponse> {
        val query = jpql {
            selectNew<RecruitmentWithUserResponse>(
                entity(Recruitment::class),
                entity(User::class),
            ).from(
                entity(Recruitment::class),
                join(User::class).on(path(Recruitment::userId).equal(path(User::id))),
                join(RecruitmentScrap::class).on(path(Recruitment::id).equal(path(RecruitmentScrap::recruitmentId))),
            ).where(
                path(RecruitmentScrap::userId).equal(userId),
            ).orderBy(
                path(Recruitment::id).desc(),
            )
        }

        return em.createQuery(query, context).resultList
    }

    override fun findRecruitmentScrollPageByUserId(
        userId: Long,
        request: RecruitmentScrollPageRequest,
    ): List<RecruitmentWithUserResponse> {
        val query = jpql {
            selectNew<RecruitmentWithUserResponse>(
                entity(Recruitment::class),
                entity(User::class),
            ).from(
                entity(Recruitment::class),
                join(User::class).on(path(Recruitment::userId).equal(path(User::id))),
            ).whereAnd(
                path(Recruitment::id).lessThan(request.lastId ?: Long.MAX_VALUE),
                path(Recruitment::userId).equal(userId),
            ).orderBy(
                path(Recruitment::id).desc(),
            )
        }

        return em.createQuery(query, context).setMaxResults(request.size).resultList
    }

    override fun findRecruitmentById(id: Long): RecruitmentWithUserResponse {
        val query = jpql {
            selectNew<RecruitmentWithUserResponse>(
                entity(Recruitment::class),
                entity(User::class),
            ).from(
                entity(Recruitment::class),
                join(User::class).on(path(Recruitment::userId).equal(path(User::id))),
            ).where(
                path(Recruitment::id).equal(id),
            )
        }

        return em.createQuery(query, context).singleResult
    }

    private fun Jpql.searchOption(request: RecruitmentScrollPageRequest): Predicatable? {
        return if (request.keyword != null) {
            or(
                path(Recruitment::title).like("%${request.keyword}%"),
                path(Recruitment::content).like("%${request.keyword}%"),
            )
        } else {
            null
        }
    }
}
