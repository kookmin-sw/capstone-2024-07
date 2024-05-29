package com.dclass.backend.exception.common

import org.springframework.http.HttpStatus

interface BaseExceptionType {
    fun httpStatus(): HttpStatus
    fun code(): String
    fun errorMessage(): String
}
