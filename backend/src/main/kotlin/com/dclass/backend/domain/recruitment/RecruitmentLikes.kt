package com.dclass.backend.domain.recruitment

import jakarta.persistence.CollectionTable
import jakarta.persistence.ElementCollection
import jakarta.persistence.Embeddable
import jakarta.persistence.FetchType

@Embeddable
class RecruitmentLikes(
    likes: List<RecruitmentLike> = emptyList(),
) {
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "recruitment_likes")
    private val _likes: MutableList<RecruitmentLike> = likes.toMutableList()

    val likes: List<RecruitmentLike>
        get() = _likes

    val count: Int
        get() = _likes.size

    fun add(userId: Long) {
        _likes.removeIf { it.usersId == userId }
        _likes.add(RecruitmentLike(userId))
    }

    fun likedBy(userId: Long): Boolean {
        return _likes.any { it.usersId == userId }
    }
}
