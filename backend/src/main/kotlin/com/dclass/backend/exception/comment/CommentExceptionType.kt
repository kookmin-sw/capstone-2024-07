package com.dclass.backend.exception.comment

import com.dclass.backend.exception.common.BaseExceptionType
import org.springframework.http.HttpStatus

enum class CommentExceptionType(
    private val httpStatus: HttpStatus,
    private val code: String,
    private val errorMessage: String,
) : BaseExceptionType {

    FORBIDDEN_COMMENT(HttpStatus.FORBIDDEN, "C00", "댓글에 대한 권한이 없습니다."),
    NOT_FOUND_COMMENT(HttpStatus.NOT_FOUND, "C01", "해당 댓글을 찾을 수 없습니다."),
    SELF_LIKE(HttpStatus.BAD_REQUEST, "C02", "본인이 작성한 댓글에는 좋아요를 누를 수 없습니다."),
    DELETED_COMMENT(HttpStatus.BAD_REQUEST, "C03", "삭제된 댓글 입니다."),
    ;

    override fun httpStatus(): HttpStatus {
        return httpStatus
    }

    override fun code(): String {
        return code
    }

    override fun errorMessage(): String {
        return errorMessage
    }
}
