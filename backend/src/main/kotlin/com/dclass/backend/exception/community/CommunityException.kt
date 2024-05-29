package com.dclass.backend.exception.community

import com.dclass.backend.exception.common.BaseException

class CommunityException(
    private val exceptionType: CommunityExceptionType,
) : BaseException() {
    override fun exceptionType(): CommunityExceptionType {
        return exceptionType
    }
}
