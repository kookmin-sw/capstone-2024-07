package com.dclass.backend.domain.recruitmentcomment

import jakarta.persistence.CollectionTable
import jakarta.persistence.ElementCollection
import jakarta.persistence.Embeddable
import jakarta.persistence.FetchType

@Embeddable
class RecruitmentCommentLikes(
    likes: List<RecruitmentCommentLike> = emptyList(),
) {
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "comment_likes")
    private val _likes: MutableList<RecruitmentCommentLike> = likes.toMutableList()

    val likes: List<RecruitmentCommentLike>
        get() = _likes

    val count: Int
        get() = _likes.size

    fun add(userId: Long) {
        _likes.removeIf { it.usersId == userId }
        _likes.add(RecruitmentCommentLike(userId))
    }

    fun findUserById(userId: Long) =
        _likes.any { it.usersId == userId }
}
