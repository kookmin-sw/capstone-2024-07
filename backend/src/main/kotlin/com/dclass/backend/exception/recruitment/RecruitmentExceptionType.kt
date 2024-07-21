package com.dclass.backend.exception.recruitment

import com.dclass.backend.exception.common.BaseExceptionType
import org.springframework.http.HttpStatus

enum class RecruitmentExceptionType(
    private val httpStatus: HttpStatus,
    private val code: String,
    private val errorMessage: String,
) : BaseExceptionType {

    NOT_FOUND_RECRUITMENT(HttpStatus.NOT_FOUND, "R01", "존재하지 않는 모집입니다."),
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
