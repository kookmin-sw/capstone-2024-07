package com.dclass.backend.domain.post

import com.dclass.backend.exception.post.PostException
import com.dclass.backend.exception.post.PostExceptionType
import com.dclass.support.domain.BaseEntity
import com.dclass.support.domain.Image
import jakarta.persistence.CollectionTable
import jakarta.persistence.Column
import jakarta.persistence.ElementCollection
import jakarta.persistence.Embedded
import jakarta.persistence.Entity
import jakarta.persistence.FetchType
import jakarta.persistence.Table
import jakarta.persistence.Version
import org.hibernate.annotations.SQLDelete
import org.hibernate.annotations.SQLRestriction
import java.time.LocalDateTime

@SQLDelete(sql = "update post set deleted = true where id = ? and version = ?")
@SQLRestriction("deleted = false")
@Entity
@Table
class Post(
    @Column(nullable = false)
    val userId: Long,

    @Column(nullable = false)
    var communityId: Long,

    title: String = "",

    content: String = "",

    postLikes: PostLikes = PostLikes(),

    images: List<Image> = emptyList(),

    @Embedded
    var postCount: PostCount = PostCount(),

    isQuestion: Boolean = false,

    isAnonymous: Boolean = false,

    @Column(nullable = false)
    val createdDateTime: LocalDateTime = LocalDateTime.now(),

    @Version
    val version: Long = 0L,

    modifiedDateTime: LocalDateTime = LocalDateTime.now(),

    id: Long = 0L,
) : BaseEntity(id) {

    @Column(nullable = false)
    private var deleted: Boolean = false

    @Column(nullable = false, length = 100)
    var title: String = title
        private set

    @Column(nullable = false, length = 255)
    var content: String = content
        private set

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "post_images")
    private val _images: MutableList<Image> = images.toMutableList()

    @Embedded
    var postLikes: PostLikes = postLikes
        private set

    val postLikesCount: Int
        get() = postLikes.count

    val images: List<Image>
        get() = _images

    @Column(nullable = false)
    var isQuestion: Boolean = isQuestion
        private set

    @Column(nullable = false)
    var isAnonymous: Boolean = isAnonymous
        private set

    @Column(nullable = false)
    var modifiedDateTime: LocalDateTime = modifiedDateTime
        private set

    val thumbnail: String?
        get() = _images.firstOrNull()?.imageKey

    fun update(title: String, content: String, isAnonymous: Boolean, images: List<Image>, communityId: Long) {
        this.title = title
        this.content = content
        this.isAnonymous = isAnonymous
        this._images.clear()
        this._images.addAll(images)
        this.communityId = communityId
        this.modifiedDateTime = LocalDateTime.now()
    }

    fun increaseCommentReplyCount() {
        postCount = postCount.increaseCommentReplyCount()
    }

    fun increaseScrapCount() {
        postCount = postCount.increaseScrapCount()
    }

    fun decreaseScrapCount() {
        postCount = postCount.decreaseScrapCount()
    }

    fun decreaseCommentReplyCount() {
        postCount = postCount.decreaseCommentReplyCount()
    }

    fun addLike(userId: Long) {
        if (this.userId == userId) {
            throw PostException(PostExceptionType.SELF_LIKE)
        }
        postLikes.add(userId)
        postCount = postCount.syncLikeCount(postLikesCount)
    }

    fun isEligibleForSSE(userid: Long): Boolean {
        return this.userId != userid
    }

    fun likedBy(userId: Long): Boolean {
        return postLikes.likedBy(userId)
    }
}
