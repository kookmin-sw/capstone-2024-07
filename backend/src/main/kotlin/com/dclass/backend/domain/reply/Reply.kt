package com.dclass.backend.domain.reply

import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Embedded
import jakarta.persistence.Entity
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

    fun changeContent(content: String, userId: Long) {
        if (this.userId != userId) {
            throw IllegalAccessException("댓글을 수정할 수 있는 권한이 없습니다.")
        }
        this.content = content
        modifiedDateTime = LocalDateTime.now()
    }

    fun isDeleted(replyId: Long) = deleted

    fun likedBy(userId: Long) =
        replyLikes.findUserById(userId)

    fun like(userId: Long) {
        if (this.userId == userId) {
            throw IllegalAccessException("자신이 작성한 댓글은 좋아요를 누를 수 없습니다.")
        }
        replyLikes.add(userId)
    }
}