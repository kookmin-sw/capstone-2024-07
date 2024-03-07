package com.dclass.backend.domain.reply

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.*
import org.hibernate.annotations.SQLDelete
import org.hibernate.annotations.SQLRestriction
import java.time.LocalDateTime

@SQLDelete(sql = "update reply set deleted = true where id = ?")
@SQLRestriction("deleted = false")
@Entity
class Reply(
    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    val commentId: Long,

    content: String = "",

    replyLikes: ReplyLikes = ReplyLikes(),

    @Column(nullable = false)
    val createdDateTime: LocalDateTime = LocalDateTime.now(),

    modifiedDateTime: LocalDateTime = LocalDateTime.now(),

    id: Long = 0L
) : BaseEntity(id) {

    @Column(nullable = false)
    private var deleted: Boolean = false

    @Column(nullable = false, length = 255)
    var content: String = content
        private set

    @Embedded
    var replyLikes: ReplyLikes = replyLikes
        private set

    val likeCount: Int
        get() = replyLikes.count

    @Column(nullable = false)
    var modifiedDateTime: LocalDateTime = modifiedDateTime
        private set

    fun likedBy(userId: Long) =
        replyLikes.findUserById(userId)

    fun addLike(userId: Long) {
        replyLikes.add(userId)
    }
}