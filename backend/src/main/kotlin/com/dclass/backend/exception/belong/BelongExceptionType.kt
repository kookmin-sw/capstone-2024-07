package com.dclass.backend.exception.belong

import com.dclass.backend.exception.common.BaseExceptionType
import org.springframework.http.HttpStatus

enum class BelongExceptionType(
    private val httpStatus: HttpStatus,
    private val code: String,
    private val errorMessage: String
) : BaseExceptionType {

    NOT_FOUND_BELONG(HttpStatus.NOT_FOUND, "C01", "해당 소속을 찾을 수 없습니다."),
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