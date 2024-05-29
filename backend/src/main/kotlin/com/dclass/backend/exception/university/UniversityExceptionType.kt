package com.dclass.backend.exception.university

import com.dclass.backend.exception.common.BaseExceptionType
import org.springframework.http.HttpStatus

enum class UniversityExceptionType(
    private val httpStatus: HttpStatus,
    private val code: String,
    private val errorMessage: String,
) : BaseExceptionType {

    NOT_FOUND_UNIVERSITY(HttpStatus.NOT_FOUND, "U40", "존재하지 않는 대학입니다."),
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
