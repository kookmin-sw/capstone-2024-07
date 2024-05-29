package com.dclass.backend.exception.blacklist

import com.dclass.backend.exception.common.BaseException

class BlacklistException(
    private val exceptionType: BlacklistExceptionType,
) : BaseException() {
    override fun exceptionType(): BlacklistExceptionType {
        return exceptionType
    }
}
