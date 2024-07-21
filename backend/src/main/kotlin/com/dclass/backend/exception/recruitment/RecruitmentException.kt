package com.dclass.backend.exception.recruitment

import com.dclass.backend.exception.common.BaseException

class RecruitmentException(
    private val exceptionType: RecruitmentExceptionType,
) : BaseException() {
    override fun exceptionType(): RecruitmentExceptionType {
        return exceptionType
    }
}
