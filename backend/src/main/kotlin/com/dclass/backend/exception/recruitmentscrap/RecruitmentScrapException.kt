package com.dclass.backend.exception.recruitmentscrap

import com.dclass.backend.exception.common.BaseException

class RecruitmentScrapException(
    private val exceptionType: RecruitmentScrapExceptionType,
) : BaseException() {
    override fun exceptionType(): RecruitmentScrapExceptionType {
        return exceptionType
    }
}
