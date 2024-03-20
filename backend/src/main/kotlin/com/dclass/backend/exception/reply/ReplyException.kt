package com.dclass.backend.exception.reply

import com.dclass.backend.exception.common.BaseException

class ReplyException(
    private val exceptionType: ReplyExceptionType
) : BaseException() {
    override fun exceptionType(): ReplyExceptionType {
        return exceptionType
    }
}