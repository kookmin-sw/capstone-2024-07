package com.dclass.backend.exception.university

import com.dclass.backend.exception.common.BaseException
import com.dclass.backend.exception.common.BaseExceptionType

class UniversityException(
    private val exceptionType: UniversityExceptionType
) : BaseException() {
    override fun exceptionType(): BaseExceptionType {
        return exceptionType
    }
}
