package com.dclass.backend.domain.emitter

import org.springframework.stereotype.Repository
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter
import java.util.concurrent.ConcurrentHashMap

@Repository
class EmitterRepository {
    private val emitters = ConcurrentHashMap<String, SseEmitter>()
    private val eventCache = ConcurrentHashMap<String, Any>()

    fun save(userId: String, emitter: SseEmitter): SseEmitter {
        emitters[userId] = emitter
        return emitter
    }

    fun saveEventCache(userId: String, event: Any) {
        eventCache[userId] = event
    }

    fun findAllEmitterStartWithByUserId(userId: String): Map<String, SseEmitter> {
        return emitters.filter { it.key.startsWith(userId) }
    }

    fun findAllEventCacheStartWithByUserId(userId: String): Map<String, Any> {
        return eventCache.filter { it.key.startsWith(userId) }
    }

    fun delete(userId: String) {
        emitters.remove(userId)
    }

    fun deleteAllEmitterStartWithByUserId(userId: String) {
        emitters.keys.filter { it.startsWith(userId) }.forEach { emitters.remove(it) }
    }

    fun deleteAllEventCacheStartWithByUserId(userId: String) {
        eventCache.keys.filter { it.startsWith(userId) }.forEach { eventCache.remove(it) }
    }

    fun get(userId: String): SseEmitter? {
        return emitters[userId]
    }
}