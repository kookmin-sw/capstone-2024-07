package com.dclass.support.domain

import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.MappedSuperclass
import org.springframework.data.domain.AbstractAggregateRoot
import java.util.*

@MappedSuperclass
abstract class BaseEntity(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0L,
) {
    override fun equals(other: Any?): Boolean =
        Objects.equals(id, (other as? BaseEntity)?.id)

    override fun hashCode(): Int =
        Objects.hashCode(id)
}

@MappedSuperclass
abstract class BaseRootEntity<T : AbstractAggregateRoot<T>>(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0L,
) : AbstractAggregateRoot<T>() {
    override fun equals(other: Any?): Boolean =
        Objects.equals(id, (other as? BaseRootEntity<T>)?.id)

    override fun hashCode(): Int =
        Objects.hashCode(id)
}
