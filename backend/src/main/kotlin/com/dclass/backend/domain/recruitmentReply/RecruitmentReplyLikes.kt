package com.dclass.backend.domain.recruitmentReply

import jakarta.persistence.CollectionTable
import jakarta.persistence.ElementCollection
import jakarta.persistence.Embeddable
import jakarta.persistence.FetchType

@Embeddable
class RecruitmentReplyLikes(
    likes: List<RecruitmentReplyLike> = emptyList(),
) {
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "recruitment_reply_likes")
    private val _likes: MutableList<RecruitmentReplyLike> = likes.toMutableList()

    val likes: List<RecruitmentReplyLike>
        get() = _likes

    val count: Int
        get() = _likes.size

    fun add(userId: Long) {
        _likes.removeIf { it.usersId == userId }
        _likes.add(RecruitmentReplyLike(userId))
    }

    fun findUserById(userId: Long): Boolean {
        return _likes.any { it.usersId == userId }
    }
}
