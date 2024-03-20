package com.dclass.backend.exception.reply

import com.dclass.backend.exception.common.BaseExceptionType
import org.springframework.http.HttpStatus

enum class ReplyExceptionType(
    private val httpStatus: HttpStatus,
    private val code: String,
    private val errorMessage: String
) : BaseExceptionType {

    NOT_FOUND_REPLY(HttpStatus.NOT_FOUND, "R01", "존재하지 않는 댓글입니다."),
    SELF_LIKE(HttpStatus.BAD_REQUEST, "R02", "본인이 작성한 대댓글에는 좋아요를 누를 수 없습니다.")
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