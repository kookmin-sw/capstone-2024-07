package com.dclass.backend.application

import com.dclass.backend.application.dto.NotificationRequest
import com.dclass.backend.domain.emitter.EmitterRepository
import com.dclass.backend.domain.notification.NotificationRepository
import com.dclass.backend.domain.notification.getOrThrow
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter

@Service
@Transactional
class NotificationService(
    val emitterRepository: EmitterRepository,
    val notificationRepository: NotificationRepository,
) {
    private val DEFAULT_TIMEOUT = 60L * 1000L * 60L

    fun subscribe(id: Long, lastEventId: String): SseEmitter {
        val emitterId = makeTimeIncludeId(id)
        val emitter = emitterRepository.save(emitterId, SseEmitter(DEFAULT_TIMEOUT))
        emitter.onCompletion { emitterRepository.delete(emitterId) }
        emitter.onTimeout { emitterRepository.delete(emitterId) }

        sendNotification(emitter, makeTimeIncludeId(id), emitterId, "EventStream Created. [userId=$id]")

        if (hasLostData(lastEventId)) {
            sendLostData(emitter, lastEventId, emitterId, id)
        }

        return emitter;
    }


    fun send(request: NotificationRequest) {
        val notification = notificationRepository.save(request.toEntity())

        val eventId = makeTimeIncludeId(request.userId)
        val emitters = emitterRepository.findAllEmitterStartWithByUserId(request.userId.toString())
        emitters.forEach { (key, emitter) ->
            run {
                val response = request.createResponse(notification.id, notification.createdAt)
                emitterRepository.saveEventCache(key, notification)
                sendNotification(emitter, eventId, key, response)
            }
        }
    }
    
    fun readNotification(id: Long) {
        val notification = notificationRepository.getOrThrow(id)
        notification.read()
    }

    private fun makeTimeIncludeId(id: Long): String {
        return "${id}_${System.currentTimeMillis()}"
    }

    private fun sendNotification(emitter: SseEmitter, eventId: String, emitterId: String, data: Any) {
        try {
            emitter.send(
                SseEmitter.event()
                    .id(eventId)
                    .name(emitterId)
                    .data(data)
            )
        } catch (e: Exception) {
            emitterRepository.delete(emitterId)
        }
    }

    private fun hasLostData(lastEventId: String): Boolean {
        return lastEventId.isNotEmpty()
    }

    private fun sendLostData(emitter: SseEmitter, lastEventId: String, emitterId: String, userId: Long) {
        val eventCache = emitterRepository.findAllEventCacheStartWithByUserId(userId.toString())
        eventCache.filter { it.key > lastEventId }.forEach {
            sendNotification(emitter, it.key, emitterId, it.value)
        }
    }

}