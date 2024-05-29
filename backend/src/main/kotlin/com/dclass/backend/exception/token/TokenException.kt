package com.dclass.backend.exception.token

import com.dclass.backend.exception.common.BaseException

class TokenException(
    private val exceptionType: TokenExceptionType,
) : BaseException() {
    override fun exceptionType(): TokenExceptionType {
        return exceptionType
    }
}
