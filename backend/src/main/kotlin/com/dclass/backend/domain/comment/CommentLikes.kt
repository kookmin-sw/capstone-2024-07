package com.dclass.backend.domain.comment

import jakarta.persistence.CollectionTable
import jakarta.persistence.ElementCollection
import jakarta.persistence.Embeddable
import jakarta.persistence.FetchType

@Embeddable
class CommentLikes(
    likes: List<CommentLike> = emptyList()
) {
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "comment_likes")
    private val _likes: MutableList<CommentLike> = likes.toMutableList()

    val likes: List<CommentLike>
        get() = _likes

    val count: Int
        get() = _likes.size

    fun add(userId: Long) {
        _likes.removeIf { it.usersId == userId }
        _likes.add(CommentLike(userId))
    }

    fun findUserById(userId: Long) =
        _likes.any { it.usersId == userId }
}