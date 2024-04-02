package com.dclass.backend.ui.api

import com.dclass.backend.application.NotificationService
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.responses.ApiResponse
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter

@RestController
@RequestMapping("/api/notifications")
class NotificationController(
    private val notificationService: NotificationService
) {

    @Operation(summary = "알림 구독 API", description = "알림을 구독합니다")
    @ApiResponse(responseCode = "200", description = "알림 구독 성공")
    @GetMapping("/subscribe", produces = [MediaType.TEXT_EVENT_STREAM_VALUE])
    fun subscribe(
        @LoginUser user: User,
        @RequestHeader(value = "Last-Event_ID", required = false, defaultValue = "") lastEventId: String
    ): ResponseEntity<SseEmitter> {
        val emitter = notificationService.subscribe(user.id, lastEventId)
        return ResponseEntity.ok(emitter)
    }

    @Operation(summary = "알림 조회 API", description = "알림을 조회합니다")
    @ApiResponse(responseCode = "200", description = "알림 조회 성공")
    @GetMapping("/{notificationId}")
    fun readNotification(
        @LoginUser user: User,
        @PathVariable notificationId: Long
    ): ResponseEntity<Unit> {
        notificationService.readNotification(notificationId)
        return ResponseEntity.ok().build()
    }
}