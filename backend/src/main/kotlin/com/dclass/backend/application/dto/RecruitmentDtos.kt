package com.dclass.backend.application.dto

import com.dclass.backend.domain.hashtag.HashTag
import com.dclass.backend.domain.recruitment.Recruitment
import com.dclass.backend.domain.recruitment.RecruitmentNumber
import com.dclass.backend.domain.recruitment.RecruitmentType
import com.dclass.backend.domain.recruitmentanonymous.RecruitmentAnonymous
import com.dclass.backend.domain.user.User
import java.time.LocalDateTime

data class CreateRecruitmentRequest(
    val type: RecruitmentType,
    val isOnline: Boolean,
    val isOngoing: Boolean,
    val limit: Int,
    val startDateTime: LocalDateTime,
    val endDateTime: LocalDateTime,
    var title: String,
    var content: String,
    val hashTags: List<String>,
    val isAnonymous: Boolean = false,
) {
    fun toRecruitment(userId: Long, departmentId: Long): Recruitment {
        return Recruitment(
            userId = userId,
            departmentId = departmentId,
            type = type,
            isOnline = isOnline,
            isOngoing = isOngoing,
            limit = RecruitmentNumber(limit),
            startDateTime = startDateTime,
            endDateTime = endDateTime,
            title = title,
            content = content,
            isAnonymous = isAnonymous,
        )
    }

    fun toAnonymousEntity(userId: Long, recruitmentId: Long): RecruitmentAnonymous {
        return RecruitmentAnonymous(userId, recruitmentId)
    }
}

data class RecruitmentResponse(
    val id: Long,
    val userId: Long,
    val title: String,
    val content: String,
) {
    constructor(recruitment: Recruitment) : this(
        id = recruitment.id,
        userId = recruitment.userId,
        title = recruitment.title,
        content = recruitment.content,
    )
}

data class RecruitmentScrollPageRequest(
    val lastId: Long? = null,
    val size: Int = 10,
    val keyword: String? = null,
)

data class RecruitmentWithUserResponse(
    val id: Long,
    val departmentId: Long,
    val type: RecruitmentType,
    val isOnline: Boolean,
    val isOngoing: Boolean,
    val limit: Int,
    val recruitable: Boolean,
    val startDateTime: LocalDateTime,
    val endDateTime: LocalDateTime,
    val title: String,
    val content: String,
    val scrapCount: Int,
    val commentReplyCount: Int,
    val createdDateTime: LocalDateTime,
    val modifiedDateTime: LocalDateTime,
    val userId: Long,
    val isAnonymous: Boolean,
    var userNickname: String,
) {
    constructor(recruitment: Recruitment, user: User) : this(
        recruitment.id,
        recruitment.departmentId,
        recruitment.type,
        recruitment.isOnline,
        recruitment.isOngoing,
        recruitment.limit.number,
        recruitment.recruitable,
        recruitment.startDateTime,
        recruitment.endDateTime,
        recruitment.title,
        recruitment.content,
        recruitment.scrapCount,
        recruitment.commentCount,
        recruitment.createdDateTime,
        recruitment.modifiedDateTime,
        recruitment.userId,
        recruitment.isAnonymous,
        user.nickname,
    )
}

data class RecruitmentWithUserAndHashTagResponse(
    val id: Long,
    val departmentId: Long,
    val type: RecruitmentType,
    val isOnline: Boolean,
    val isOngoing: Boolean,
    val limit: Int,
    val recruitable: Boolean,
    val startDateTime: LocalDateTime,
    val endDateTime: LocalDateTime,
    val title: String,
    val content: String,
    val scrapCount: Int,
    val commentReplyCount: Int,
    val createdDateTime: LocalDateTime,
    val modifiedDateTime: LocalDateTime,
    val userId: Long,
    val userNickname: String,
    val hashTags: List<HashTag>,
) {
    constructor(recruitment: RecruitmentWithUserResponse, hashTags: List<HashTag>) : this(
        recruitment.id,
        recruitment.departmentId,
        recruitment.type,
        recruitment.isOnline,
        recruitment.isOngoing,
        recruitment.limit,
        recruitment.recruitable,
        recruitment.startDateTime,
        recruitment.endDateTime,
        recruitment.title,
        recruitment.content,
        recruitment.scrapCount,
        recruitment.commentReplyCount,
        recruitment.createdDateTime,
        recruitment.modifiedDateTime,
        recruitment.userId,
        recruitment.userNickname,
        hashTags,
    )
}

data class RecruitmentsResponse(
    val data: List<RecruitmentWithUserAndHashTagResponse>,
    val meta: MetaData,
) {
    companion object {
        fun of(data: List<RecruitmentWithUserAndHashTagResponse>, limit: Int): RecruitmentsResponse {
            return RecruitmentsResponse(data, MetaData(data.size, data.size >= limit))
        }
    }
}

data class RecruitmentWithUserAndHashTagDetailResponse(
    val id: Long,
    val departmentId: Long,
    val type: RecruitmentType,
    val isOnline: Boolean,
    val isOngoing: Boolean,
    val limit: Int,
    val recruitable: Boolean,
    val startDateTime: LocalDateTime,
    val endDateTime: LocalDateTime,
    val title: String,
    val content: String,
    val scrapCount: Int,
    val commentReplyCount: Int,
    val createdDateTime: LocalDateTime,
    val modifiedDateTime: LocalDateTime,
    val userId: Long,
    val userNickname: String,
    val hashTags: List<HashTag>,
    val isScrapped: Boolean,
) {
    constructor(recruitment: RecruitmentWithUserResponse, hashTags: List<HashTag>, isScrapped: Boolean) : this(
        recruitment.id,
        recruitment.departmentId,
        recruitment.type,
        recruitment.isOnline,
        recruitment.isOngoing,
        recruitment.limit,
        recruitment.recruitable,
        recruitment.startDateTime,
        recruitment.endDateTime,
        recruitment.title,
        recruitment.content,
        recruitment.scrapCount,
        recruitment.commentReplyCount,
        recruitment.createdDateTime,
        recruitment.modifiedDateTime,
        recruitment.userId,
        recruitment.userNickname,
        hashTags,
        isScrapped,
    )
}

data class UpdateRecruitmentRequest(
    val recruitmentId: Long,
    val type: RecruitmentType,
    val isOnline: Boolean,
    val isOngoing: Boolean,
    val limit: Int,
    val startDateTime: LocalDateTime,
    val endDateTime: LocalDateTime,
    var title: String,
    var content: String,
    val hashTags: List<String>,
    val recruitable: Boolean,
)
