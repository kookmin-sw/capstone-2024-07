package com.dclass.backend.domain.post

import jakarta.persistence.CollectionTable
import jakarta.persistence.Column
import jakarta.persistence.ElementCollection
import jakarta.persistence.Embeddable
import jakarta.persistence.FetchType

@Embeddable
class PostCommentIds(
    commentIds: Map<Long, Long> = HashMap(),
) {
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "post_comment_ids")
    private val _commentIds: MutableMap<Long, Long> = HashMap(commentIds)

    val commentIds: Map<Long, Long>
        get() = _commentIds

    @Column(name = "next_value")
    var nextValue: Long = determineNextValue(commentIds)
        private set

    private fun determineNextValue(commentIds: Map<Long, Long>): Long {
        return (commentIds.values.maxOrNull() ?: 0) + 1
    }

    @Synchronized
    fun add(userId: Long) {
        if (!_commentIds.containsKey(userId)) {
            _commentIds[userId] = nextValue++
        }
    }
}
