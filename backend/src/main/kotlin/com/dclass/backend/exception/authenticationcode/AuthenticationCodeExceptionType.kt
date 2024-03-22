package com.dclass.backend.exception.authenticationcode

import com.dclass.backend.exception.common.BaseExceptionType
import org.springframework.http.HttpStatus

enum class AuthenticationCodeExceptionType(
    private val httpStatus: HttpStatus,
    private val code: String,
    private val errorMessage: String
) : BaseExceptionType {

    NOT_EQUAL_CODE(HttpStatus.BAD_REQUEST, "A01", "인증 코드가 일치하지 않습니다"),
    ALREADY_VERIFIED(HttpStatus.BAD_REQUEST, "A02", "이미 인증된 코드입니다"),
    EXPIRED_CODE(HttpStatus.BAD_REQUEST, "A03", "만료된 코드입니다"),
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