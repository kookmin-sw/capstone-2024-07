package com.dclass.backend.exception.department

import com.dclass.backend.exception.common.BaseException

class DepartmentException(
    private val exceptionType: DepartmentExceptionType
) : BaseException() {
    override fun exceptionType(): DepartmentExceptionType {
        return exceptionType
    }
}