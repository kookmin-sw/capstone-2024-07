package com.dclass.backend.exception.belong

import com.dclass.backend.exception.common.BaseException

class BelongException(
    private val exceptionType: BelongExceptionType,
) : BaseException() {
    override fun exceptionType(): BelongExceptionType {
        return exceptionType
    }
}
