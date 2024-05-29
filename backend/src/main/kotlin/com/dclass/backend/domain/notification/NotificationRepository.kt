package com.dclass.backend.domain.notification

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.repository.findByIdOrNull

fun NotificationRepository.getOrThrow(id: Long): Notification = findByIdOrNull(id)
    ?: throw IllegalArgumentException("Notification not found")

interface NotificationRepository : JpaRepository<Notification, Long> {
    fun findAllByUserId(userId: Long): List<Notification>
}
