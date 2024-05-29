package com.dclass.backend.domain.report

import com.linecorp.kotlinjdsl.dsl.jpql.jpql
import com.linecorp.kotlinjdsl.render.jpql.JpqlRenderContext
import com.linecorp.kotlinjdsl.support.spring.data.jpa.extension.createQuery
import jakarta.persistence.EntityManager

interface ReportRepositorySupport {
    fun countReportById(objectId: Long, type: ReportType): Long
}

class ReportRepositoryImpl(
    private val em: EntityManager,
    private val context: JpqlRenderContext,
) : ReportRepositorySupport {
    override fun countReportById(objectId: Long, type: ReportType): Long {
        val query = jpql {
            select(
                count(entity(Report::class)),
            ).from(
                entity(Report::class),
            ).whereAnd(
                path(Report::reportedObjectId).eq(objectId),
                path(Report::reportType).eq(type),
            )
        }

        return em.createQuery(query, context).singleResult
    }
}
