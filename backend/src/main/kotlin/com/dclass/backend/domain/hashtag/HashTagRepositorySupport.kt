package com.dclass.backend.domain.hashtag

import com.linecorp.kotlinjdsl.dsl.jpql.jpql
import com.linecorp.kotlinjdsl.render.jpql.JpqlRenderContext
import com.linecorp.kotlinjdsl.support.spring.data.jpa.extension.createQuery
import jakarta.persistence.EntityManager

interface HashTagRepositorySupport {
    fun deleteAllByIdIn(ids: List<Long>): Int
}

class HashTagRepositoryImpl(
    private val em: EntityManager,
    private val context: JpqlRenderContext,
) : HashTagRepositorySupport {
    override fun deleteAllByIdIn(ids: List<Long>): Int {
        val query = jpql {
            deleteFrom(entity(HashTag::class))
                .where(path(HashTag::id).`in`(ids))
        }

        return em.createQuery(query, context).executeUpdate()
    }
}
