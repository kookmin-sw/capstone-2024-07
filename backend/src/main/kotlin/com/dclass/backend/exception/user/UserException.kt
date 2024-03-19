package com.dclass.backend.exception.user

import com.dclass.backend.exception.common.BaseException
import com.dclass.backend.exception.community.CommunityExceptionType

class UserException(
    private val exceptionType: UserExceptionType
) : BaseException() {
    override fun exceptionType(): UserExceptionType {
        return exceptionType
    }
}