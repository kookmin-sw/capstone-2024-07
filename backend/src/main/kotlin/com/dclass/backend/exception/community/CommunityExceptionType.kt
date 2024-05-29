package com.dclass.backend.exception.community

import com.dclass.backend.exception.common.BaseExceptionType
import org.springframework.http.HttpStatus

enum class CommunityExceptionType(
    private val httpStatus: HttpStatus,
    private val code: String,
    private val errorMessage: String,
) : BaseExceptionType {

    NOT_FOUND_COMMUNITY(HttpStatus.NOT_FOUND, "C01", "존재하지 않는 커뮤니티입니다."),
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
