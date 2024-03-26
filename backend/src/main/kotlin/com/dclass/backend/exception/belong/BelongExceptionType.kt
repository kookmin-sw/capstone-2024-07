package com.dclass.backend.exception.belong

import com.dclass.backend.exception.common.BaseExceptionType
import org.springframework.http.HttpStatus

enum class BelongExceptionType(
    private val httpStatus: HttpStatus,
    private val code: String,
    private val errorMessage: String
) : BaseExceptionType {

    NOT_FOUND_BELONG(HttpStatus.NOT_FOUND, "B01", "해당 소속을 찾을 수 없습니다."),
    MAX_BELONG(HttpStatus.BAD_REQUEST, "B02", "소속은 최대 2개까지만 설정할 수 있습니다."),
    CHANGE_INTERVAL_VIOLATION(HttpStatus.BAD_REQUEST, "B03", "학과 변경은 최대 90일마다 가능합니다."),
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