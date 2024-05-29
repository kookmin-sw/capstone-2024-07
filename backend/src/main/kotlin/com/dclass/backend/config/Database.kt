package com.dclass.backend.config

import jakarta.persistence.EntityManager
import org.springframework.context.annotation.Profile
import org.springframework.stereotype.Component

interface Database {

    fun retrieveTables(): List<String>
    fun clear(tableNames: List<String>)
}

abstract class AbstractDatabase(
    private val entityManager: EntityManager,
) : Database {
    override fun clear(tableNames: List<String>) {
        entityManager.createNativeQuery(constraintsOffSql).executeUpdate()
        tableNames
            .forEach { entityManager.createNativeQuery(createTruncateTableSql(it)).executeUpdate() }
        entityManager.createNativeQuery(constraintsOnSql).executeUpdate()
    }

    override fun retrieveTables(): List<String> {
        return entityManager.createNativeQuery(metaTablesSql).resultList
            .map { it.toString() }
    }

    abstract val metaTablesSql: String
    abstract val constraintsOffSql: String
    abstract val constraintsOnSql: String
    abstract fun createTruncateTableSql(tableName: String): String
}

@Profile("local")
@Component
class MySql(
    entityManager: EntityManager,
) : AbstractDatabase(entityManager) {
    override val metaTablesSql: String = "show tables"
    override val constraintsOffSql: String = "set foreign_key_checks = 0"
    override val constraintsOnSql: String = "set foreign_key_checks = 1"
    override fun createTruncateTableSql(tableName: String): String = "truncate table $tableName"
}
