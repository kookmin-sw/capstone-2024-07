package com.dclass.backend.exception.scrap

import com.dclass.backend.exception.common.BaseException

class ScrapException(
    private val exceptionType: ScrapExceptionType
) : BaseException() {
    override fun exceptionType(): ScrapExceptionType {
        return exceptionType
    }
}