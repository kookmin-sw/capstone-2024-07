package com.dclass.backend.exception.common

abstract class BaseException : RuntimeException() {
    abstract fun exceptionType(): BaseExceptionType
}
