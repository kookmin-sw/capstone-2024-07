package com.dclass.backend.exception.scrap

import com.dclass.backend.exception.common.BaseExceptionType
import org.springframework.http.HttpStatus

enum class ScrapExceptionType(
    private val httpStatus: HttpStatus,
    private val code: String,
    private val errorMessage: String,
) : BaseExceptionType {

    ALREADY_SCRAP_POST(HttpStatus.FORBIDDEN, "S01", "이미 스크랩한 게시물입니다."),
    PERMISSION_DENIED(HttpStatus.FORBIDDEN, "S02", "자신이 속한 학과 게시물만 스크랩 할 수 있습니다."),
    NOT_FOUND_SCRAP(HttpStatus.NOT_FOUND, "S03", "스크랩한 게시물이 존재하지 않습니다."),
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
