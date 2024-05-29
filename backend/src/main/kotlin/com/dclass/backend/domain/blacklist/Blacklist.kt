package com.dclass.backend.domain.blacklist

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity
import org.hibernate.annotations.SQLDelete
import org.hibernate.annotations.SQLRestriction

@SQLDelete(sql = "update blacklist set deleted = true where id = ?")
@SQLRestriction("deleted = false")
@Entity
class Blacklist(
    @Column(nullable = false)
    val invalidRefreshToken: String,
    id: Long = 0L,
) : BaseEntity(id) {
    @Column(nullable = false)
    private var deleted: Boolean = false
}
