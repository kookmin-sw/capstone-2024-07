package com.dclass.backend.application

import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.post.getByIdOrThrow
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.concurrent.ConcurrentHashMap

@Transactional
@Service
class PostViewSyncService(
    private val postRepository: PostRepository
) {
    companion object {
        private const val VIEW_SYNC_INTERVAL = 10000L
    }

    private val productViewMap = ConcurrentHashMap<Long, Int>()

    fun addView(postId: Long) {
        productViewMap.merge(postId, 1, Int::plus)
    }

    @Scheduled(fixedDelay = VIEW_SYNC_INTERVAL)
    fun syncView() {
        productViewMap.forEach { (postId, viewCount) ->
            val post = postRepository.getByIdOrThrow(postId)
            post.increaseViewCount(viewCount)
        }
        productViewMap.clear()
    }
}