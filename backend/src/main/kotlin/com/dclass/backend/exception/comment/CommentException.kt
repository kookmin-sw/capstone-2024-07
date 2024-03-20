package com.dclass.backend.exception.comment

import com.dclass.backend.exception.common.BaseException

class CommentException(
    private val exceptionType: CommentExceptionType
) : BaseException() {
    override fun exceptionType(): CommentExceptionType {
        return exceptionType
    }
}