package com.dclass.backend.exception.blocklist

import com.dclass.backend.exception.common.BaseExceptionType
import org.springframework.http.HttpStatus

enum class BlocklistExceptionType(
    private val httpStatus: HttpStatus,
    private val code: String,
    private val errorMessage: String
) : BaseExceptionType {
    NOT_FOUND_USER(HttpStatus.NOT_FOUND, "B01", "정지된 사용자가 아닙니다."),
    BLOCKED_USER(HttpStatus.FORBIDDEN, "B02", "정지된 사용자입니다.")
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
