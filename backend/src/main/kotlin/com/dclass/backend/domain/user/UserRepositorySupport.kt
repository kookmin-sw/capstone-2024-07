package com.dclass.backend.domain.user

import com.dclass.backend.application.dto.UserResponseWithDepartment
import com.dclass.backend.domain.belong.Belong
import com.linecorp.kotlinjdsl.dsl.jpql.jpql
import com.linecorp.kotlinjdsl.render.jpql.JpqlRenderContext
import com.linecorp.kotlinjdsl.support.spring.data.jpa.extension.createQuery
import jakarta.persistence.EntityManager

interface UserRepositorySupport {
    fun findUserInfoWithDepartment(id: Long): UserResponseWithDepartment
}

class UserRepositoryImpl(
    private val em: EntityManager,
    private val context: JpqlRenderContext,
) : UserRepositorySupport {
    override fun findUserInfoWithDepartment(id: Long): UserResponseWithDepartment {
        val query = jpql {
            selectNew<UserResponseWithDepartment>(
                entity(User::class),
                entity(Belong::class),
            ).from(
                entity(User::class),
                join(Belong::class).on(path(Belong::userId).eq(path(User::id))),
            ).where(
                path(Belong::userId).eq(id)
            )
        }

        return em.createQuery(query, context).singleResult
    }
}
