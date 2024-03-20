package com.dclass.backend.exception.post

import com.dclass.backend.exception.common.BaseException

class PostException(
    private val exceptionType: PostExceptionType
) : BaseException() {
    override fun exceptionType(): PostExceptionType {
        return exceptionType
    }
}