package com.dclass.backend.domain.notification

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "notifications")
class Notification(
    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val postId: Long,

    @Column(nullable = false)
    val content: String,

    @Column(nullable = false)
    var isRead: Boolean = false,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    val type: NotificationType,

    @Column(nullable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),

    id: Long = 0L
) : BaseEntity(id) {
    fun read() {
        isRead = true
    }
}