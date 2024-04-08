package com.dclass.backend.domain.post

import jakarta.persistence.CollectionTable
import jakarta.persistence.ElementCollection
import jakarta.persistence.Embeddable
import jakarta.persistence.FetchType

@Embeddable
class PostLikes(
    likes: List<PostLike> = emptyList()
) {
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "post_likes")
    private val _likes: MutableList<PostLike> = likes.toMutableList()

    val likes: List<PostLike>
        get() = _likes

    val count: Int
        get() = _likes.size

    fun add(userId: Long) {
        _likes.removeIf { it.usersId == userId }
        _likes.add(PostLike(userId))
    }

    fun likedBy(userId: Long): Boolean {
        return _likes.any { it.usersId == userId }
    }
}