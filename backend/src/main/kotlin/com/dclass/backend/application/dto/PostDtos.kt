package com.dclass.backend.application.dto

import com.dclass.backend.domain.community.CommunityType
import com.dclass.backend.domain.post.Post
import com.dclass.backend.domain.post.PostCount
import com.dclass.backend.domain.user.User
import com.dclass.support.domain.Image
import io.swagger.v3.oas.annotations.media.Schema
import java.time.LocalDateTime


data class PostScrollPageRequest(
    @Schema(
        description = "게시글의 마지막 식별자",
        example = "1"
    )
    val lastId: Long? = null,

    @Schema(
        description = "커뮤니티 타이틀",
        example = "자유게시판"
    )
    var communityTitle: String? = null,

    @Schema(
        description = "게시글의 개수",
        example = "10"
    )
    val size: Int,

    @Schema(
        description = "게시글의 인기순 정렬 여부",
        example = "true"
    )
    val isHot: Boolean = false,

    @Schema(
        description = "검색 키워드",
        example = "검색 키워드"
    )
    val keyword: String? = null,
) {
    init {
        communityTitle = CommunityType.from(communityTitle)?.name
    }
}

/**
 * modifiedDateTime은 필요할까?
 */
data class PostResponse(
    @Schema(
        description = "게시글의 고유 식별자",
        example = "1"
    )
    val id: Long,

    @Schema(
        description = "게시글을 작성한 사용자의 고유 식별자",
        example = "1"
    )
    val userId: Long,

    @Schema(
        description = "게시글을 작성한 사용자의 닉네임",
        example = "닉네임"
    )
    val userNickname: String,

    @Schema(
        description = "게시글을 작성한 사용자의 대학교 이름",
        example = "대학교 이름"
    )
    val universityName: String,

    @Schema(
        description = "게시글이 속한 커뮤니티의 고유 식별자",
        example = "1"
    )
    val communityId: Long,

    @Schema(
        description = "게시글이 속한 커뮤니티의 타이틀",
        example = "자유게시판"
    )
    var communityTitle: String,

    @Schema(
        description = "게시글의 제목",
        example = "게시글 제목"
    )
    val postTitle: String,

    @Schema(
        description = "게시글의 내용",
        example = "게시글 내용"
    )
    val postContent: String,

    @Schema(
        description = "게시글의 이미지 URL 리스트",
        example = "['이미지 URL']"
    )
    var images: List<String>,

    @Schema(
        description = "게시글의 조회수, 댓글수, 좋아요수",
        example = "{'view': 1, 'comment': 1, 'like': 1}"
    )
    val count: PostCount,

    @Schema(
        description = "게시글이 질문인지 여부",
        example = "true"
    )
    val isQuestion: Boolean,

    @Schema(
        description = "게시글이 작성된 시각",
        example = "2021-08-01T00:00:00"
    )
    val createdDateTime: LocalDateTime,
) {
    constructor(
        post: Post,
        user: User,
        communityTitle: String,
    ) : this(
        post.id,
        post.userId,
        user.nickname,
        user.universityName,
        post.communityId,
        communityTitle,
        post.title,
        post.content,
        post.images.map { it.imageKey },
        post.postCount,
        post.isQuestion,
        post.createdDateTime
    )

}

data class PostDetailResponse(
    @Schema(
        description = "게시글의 고유 식별자",
        example = "1"
    )
    val id: Long,

    @Schema(
        description = "게시글을 작성한 사용자의 고유 식별자",
        example = "1"
    )
    val userId: Long,

    @Schema(
        description = "게시글을 작성한 사용자의 닉네임",
        example = "닉네임"
    )
    val userNickname: String,

    @Schema(
        description = "게시글을 작성한 사용자의 대학교 이름",
        example = "대학교 이름"
    )
    val universityName: String,

    @Schema(
        description = "게시글이 속한 커뮤니티의 고유 식별자",
        example = "1"
    )
    val communityId: Long,

    @Schema(
        description = "게시글이 속한 커뮤니티의 타이틀",
        example = "자유게시판"
    )
    var communityTitle: String,

    @Schema(
        description = "게시글의 제목",
        example = "게시글 제목"
    )
    val postTitle: String,

    @Schema(
        description = "게시글의 내용",
        example = "게시글 내용"
    )
    val postContent: String,

    @Schema(
        description = "게시글의 이미지 URL 리스트",
        example = "['이미지 URL']"
    )
    var images: List<String>,

    @Schema(
        description = "게시글의 조회수, 댓글수, 좋아요수",
        example = "{'view': 1, 'comment': 1, 'like': 1}"
    )
    val count: PostCount,

    @Schema(
        description = "게시글이 질문인지 여부",
        example = "true"
    )
    val isQuestion: Boolean,

    @Schema(
        description = "게시글이 스크랩된 여부",
        example = "true"
    )
    var isScrapped: Boolean,

    @Schema(
        description = "게시글의 좋아요 여부",
        example = "true"
    )
    var likedBy : Boolean,

    @Schema(
        description = "게시글이 작성된 시각",
        example = "2021-08-01T00:00:00"
    )
    val createdDateTime: LocalDateTime,
) {

    constructor(
        post: Post,
        user: User,
        communityTitle: String,
    ) : this(
        post.id,
        post.userId,
        user.nickname,
        user.universityName,
        post.communityId,
        communityTitle,
        post.title,
        post.content,
        post.images.map { it.imageKey },
        post.postCount,
        post.isQuestion,
        false,
        false,
        post.createdDateTime
    )
}

data class CreatePostRequest(
    @Schema(
        description = "게시글이 속한 커뮤니티의 타이틀",
        example = "자유게시판"
    )
    var communityTitle: String,

    @Schema(
        description = "게시글의 제목",
        example = "게시글 제목"
    )
    val title: String,

    @Schema(
        description = "게시글의 내용",
        example = "게시글 내용"
    )
    val content: String,

    @Schema(
        description = "게시글이 질문인지 여부",
        example = "true"
    )
    val isQuestion: Boolean,

    @Schema(
        description = "게시글의 이미지 URL 리스트",
        example = "['이미지 URL']"
    )
    val images: List<String>,
) {

    fun toEntity(userId: Long, communityId: Long) = Post(
        userId = userId,
        communityId = communityId,
        title = title,
        content = content,
        images = images.map { Image(it) },
        isQuestion = isQuestion,
    )

    init {
        communityTitle = CommunityType.from(communityTitle)!!.name
    }
}

data class UpdatePostRequest(
    @Schema(
        description = "게시글의 고유 식별자",
        example = "1"
    )
    val postId: Long,

    @Schema(
        description = "게시글의 제목",
        example = "게시글 제목"
    )
    val title: String,

    @Schema(
        description = "게시글의 내용",
        example = "게시글 내용"
    )
    val content: String,

    @Schema(
        description = "게시글의 이미지 URL 리스트",
        example = "['이미지 URL']"
    )
    var images: List<String>,
)

data class DeletePostRequest(
    @Schema(
        description = "게시글의 고유 식별자",
        example = "1"
    )
    val postId: Long
)

data class MetaData(
    @Schema(
        description = "현재 페이지의 게시글 개수",
        example = "10"
    )
    val count: Int,

    @Schema(
        description = "다음 페이지가 있는지 여부",
        example = "true"
    )
    val hasMore: Boolean
)

data class PostsResponse(
    @Schema(
        description = "게시글 목록",
        example = "['게시글 목록']"
    )
    val data: List<PostResponse>,

    @Schema(
        description = "게시글 목록의 메타데이터",
        example = "{'count': 10, 'hasMore': true}"
    )
    val meta: MetaData
) {
    companion object {
        fun of(data: List<PostResponse>, limit: Int): PostsResponse {
            return PostsResponse(data, MetaData(data.size, data.size >= limit))
        }
    }
}