package com.dclass.backend.exception.post

import com.dclass.backend.exception.common.BaseExceptionType
import org.springframework.http.HttpStatus

enum class PostExceptionType(
    private val httpStatus: HttpStatus,
    private val code: String,
    private val errorMessage: String
) : BaseExceptionType {

    NOT_FOUND_POST(HttpStatus.NOT_FOUND, "P01", "존재하지 않는 게시글입니다"),
    SELF_LIKE(HttpStatus.BAD_REQUEST, "P02", "본인 게시글에 좋아요를 누를 수 없습니다"),
    FORBIDDEN_POST(HttpStatus.FORBIDDEN, "P43", "해당 커뮤니티에 게시글을 작성할 수 없습니다"),
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