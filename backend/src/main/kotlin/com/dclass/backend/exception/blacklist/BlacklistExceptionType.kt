package com.dclass.backend.exception.blacklist

import com.dclass.backend.exception.common.BaseExceptionType
import org.springframework.http.HttpStatus

enum class BlacklistExceptionType(
    private val httpStatus: HttpStatus,
    private val code: String,
    private val errorMessage: String
) : BaseExceptionType {

    ALREADY_LOGOUT(HttpStatus.UNAUTHORIZED, "B01", "이미 무효화된 토큰입니다. 다시 로그인 해주세요."),
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