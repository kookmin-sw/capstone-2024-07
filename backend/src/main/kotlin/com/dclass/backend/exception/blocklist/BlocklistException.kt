package com.dclass.backend.exception.blocklist

import com.dclass.backend.exception.common.BaseException

class BlocklistException(
    private val exceptionType: BlocklistExceptionType
) : BaseException() {
    override fun exceptionType(): BlocklistExceptionType {
        return exceptionType
    }
}