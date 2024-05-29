package com.dclass.backend.domain.department

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity
import org.hibernate.annotations.SQLDelete
import org.hibernate.annotations.SQLRestriction

@SQLDelete(sql = "update department set deleted = true where id = ?")
@SQLRestriction("deleted = false")
@Entity
class Department(
    @Column(nullable = false)
    val title: String = "",
    id: Long = 0L,
) : BaseEntity(id) {

    @Column(nullable = false)
    private var deleted: Boolean = false
}
