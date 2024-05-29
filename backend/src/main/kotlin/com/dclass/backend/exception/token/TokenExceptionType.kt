package com.dclass.backend.exception.token

import com.dclass.backend.exception.common.BaseExceptionType
import org.springframework.http.HttpStatus

enum class TokenExceptionType(
    private val httpStatus: HttpStatus,
    private val code: String,
    private val errorMessage: String,
) : BaseExceptionType {

    NOT_FOUND_TOKEN(HttpStatus.UNAUTHORIZED, "T01", "토큰이 존재하지 않습니다."),
    EXPIRED_TOKEN(HttpStatus.UNAUTHORIZED, "T02", "토큰이 만료되었습니다"),
    INVALID_TOKEN(HttpStatus.UNAUTHORIZED, "T03", "유효하지 않은 토큰입니다."),
    WRONG_TOKEN_TYPE(HttpStatus.UNAUTHORIZED, "T04", "토큰 타입이 잘못되었습니다."),
    UNSUPPORTED_TOKEN(HttpStatus.UNAUTHORIZED, "T05", "지원하지 않는 형식의 토큰입니다."),
    TOKEN_NOT_FOUND_IN_BLACKLIST(HttpStatus.UNAUTHORIZED, "T06", "로그아웃된 사용자입니다."),
    CANNOT_CREATE_TOKEN(HttpStatus.INTERNAL_SERVER_ERROR, "T07", "토큰을 생성할 수 없습니다."),
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
