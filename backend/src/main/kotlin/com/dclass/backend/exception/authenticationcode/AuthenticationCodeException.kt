package com.dclass.backend.exception.authenticationcode

import com.dclass.backend.exception.common.BaseException

class AuthenticationCodeException(
    private val exceptionType: AuthenticationCodeExceptionType
) : BaseException() {
    override fun exceptionType(): AuthenticationCodeExceptionType {
        return exceptionType
    }
}