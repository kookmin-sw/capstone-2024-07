package com.dclass.backend.exception.recruitmentscrap

import com.dclass.backend.exception.common.BaseExceptionType
import org.springframework.http.HttpStatus

enum class RecruitmentScrapExceptionType(
    private val httpStatus: HttpStatus,
    private val code: String,
    private val errorMessage: String,
) : BaseExceptionType {

    NOT_FOUND_RECRUITMENT_SCRAP(HttpStatus.NOT_FOUND, "R01", "스크랩한 게시물이 존재하지 않습니다."),
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
