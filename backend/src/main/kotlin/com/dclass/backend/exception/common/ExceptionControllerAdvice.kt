package com.dclass.backend.exception.common

import com.dclass.support.util.logger
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.MethodArgumentNotValidException
import org.springframework.web.bind.MissingServletRequestParameterException
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.RestControllerAdvice
import java.io.IOException

@RestControllerAdvice
class ExceptionControllerAdvice {

    private val log = logger()

    @ExceptionHandler(BaseException::class)
    fun handleBaseException(request: HttpServletRequest, e: BaseException): ResponseEntity<ExceptionResponse> {
        val type = e.exceptionType()
        log.warn("잘못된 요청이 들어왔습니다. URI: ${request.requestURI}, 코드: ${type.code()}, 내용:  ${type.errorMessage()}")
        return ResponseEntity.status(type.httpStatus()).body(
            ExceptionResponse(
                code = type.code(),
                message = type.errorMessage(),
            ),
        )
    }

    @ExceptionHandler(MethodArgumentNotValidException::class)
    fun handleMethodArgumentNotValid(
        request: HttpServletRequest,
        e: MethodArgumentNotValidException,
    ): ResponseEntity<ExceptionResponse> {
        val globalErrorMessage = e.globalErrors.joinToString(
            prefix = "[Global Error : ",
            separator = ", ",
            postfix = "], \t",
            transform = { "${it.defaultMessage}" },
        )
        val fieldErrorMessage = e.fieldErrors.joinToString(
            prefix = "[Field Error : ",
            separator = " ",
            postfix = "]",
            transform = { "${it.field} : ${it.defaultMessage}" },
        )
        val errorMessage = globalErrorMessage + fieldErrorMessage
        log.warn("잘못된 요청이 들어왔습니다. URI: ${request.requestURI},  내용:  $errorMessage")
        return ResponseEntity.badRequest().body(
            ExceptionResponse(
                code = "G01",
                message = errorMessage,
            ),
        )
    }

    @ExceptionHandler(MissingServletRequestParameterException::class)
    fun handleMissingServletRequestParameterException(
        request: HttpServletRequest,
        e: MissingServletRequestParameterException,
    ): ResponseEntity<ExceptionResponse> {
        val errorMessage = "${e.parameterName} 값이 누락되었습니다."
        log.warn("잘못된 요청이 들어왔습니다. URI: ${request.requestURI},  내용:  $errorMessage")
        return ResponseEntity.badRequest().body(
            ExceptionResponse(
                code = "G02",
                message = errorMessage,
            ),
        )
    }

    @ExceptionHandler(IOException::class)
    fun handleClientAbortException(request: HttpServletRequest, e: Exception) {
        log.warn("클라이언트가 연결을 끊었습니다. URI: ${request.requestURI}, ${e.message}")
    }

    @ExceptionHandler(Exception::class)
    fun handleException(request: HttpServletRequest, e: Exception): ResponseEntity<ExceptionResponse> {
        log.error("예상하지 못한 예외가 발생했습니다. URI: ${request.requestURI}, ${e.message}", e)
        return ResponseEntity.internalServerError().body(
            ExceptionResponse(
                code = "G03",
                message = "서버가 응답할 수 없습니다.",
            ),
        )
    }
}
