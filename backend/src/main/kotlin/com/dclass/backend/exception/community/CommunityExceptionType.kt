package com.dclass.backend.exception.community

import com.dclass.backend.exception.common.BaseExceptionType
import okhttp3.internal.http.HTTP_NOT_FOUND
import org.springframework.http.HttpStatus

enum class CommunityExceptionType(
    private val httpStatus: HttpStatus,
    private val code: Int,
    private val errorMessage: String
) : BaseExceptionType {

    NOT_FOUND_COMMUNITY(HttpStatus.NOT_FOUND, HTTP_NOT_FOUND, "존재하지 않는 커뮤니티입니다."),
    ;

    override fun httpStatus(): HttpStatus {
        return httpStatus
    }

    override fun code(): Int {
        return code
    }

    override fun errorMessage(): String {
        return errorMessage
    }
}