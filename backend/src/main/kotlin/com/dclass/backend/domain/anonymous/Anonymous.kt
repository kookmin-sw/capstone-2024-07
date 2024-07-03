package com.dclass.backend.domain.anonymous

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity
import org.hibernate.annotations.SQLDelete
import org.hibernate.annotations.SQLRestriction

@SQLDelete(sql = "update anonymous set deleted = true where id = ?")
@SQLRestriction("deleted = false")
@Entity
class Anonymous (
    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val postId: Long,

    id : Long = 0L
) : BaseEntity(id) {
    @Column(nullable = false)
    private var deleted: Boolean = false
}

