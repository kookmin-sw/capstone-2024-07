package com.dclass.backend.security

import com.dclass.backend.domain.user.User
import com.dclass.backend.domain.user.UserRepository
import com.dclass.backend.domain.user.getByEmailOrThrow
import com.dclass.backend.exception.token.TokenException
import com.dclass.backend.exception.token.TokenExceptionType.*
import org.springframework.core.MethodParameter
import org.springframework.http.HttpHeaders
import org.springframework.stereotype.Component
import org.springframework.web.bind.support.WebDataBinderFactory
import org.springframework.web.context.request.NativeWebRequest
import org.springframework.web.method.support.HandlerMethodArgumentResolver
import org.springframework.web.method.support.ModelAndViewContainer

private const val BEARER = "Bearer"

@Component
class LoginUserResolver(
    private val jwtTokenProvider: JwtTokenProvider,
    private val userRepository: UserRepository,
) : HandlerMethodArgumentResolver {

    override fun supportsParameter(parameter: MethodParameter): Boolean {
        return parameter.hasParameterAnnotation(LoginUser::class.java)
    }

    override fun resolveArgument(
        parameter: MethodParameter,
        mavContainer: ModelAndViewContainer?,
        webRequest: NativeWebRequest,
        binderFactory: WebDataBinderFactory?,
    ): User {
        val token = extractBearerToken(webRequest)
        jwtTokenProvider.validateToken(token)
        val userEmail = jwtTokenProvider.getSubject(token)
        return userRepository.getByEmailOrThrow(userEmail)
    }

    private fun extractBearerToken(request: NativeWebRequest): String {
        val authorization =
            request.getHeader(HttpHeaders.AUTHORIZATION) ?: throw TokenException(NOT_FOUND_TOKEN)
        val (tokenType, token) = splitToTokenFormat(authorization)
        if (tokenType != BEARER) {
            throw TokenException(WRONG_TOKEN_TYPE)
        }
        return token
    }

    private fun splitToTokenFormat(authorization: String): Pair<String, String> {
        return try {
            val tokenFormat = authorization.split(" ")
            tokenFormat[0] to tokenFormat[1]
        } catch (e: IndexOutOfBoundsException) {
            throw TokenException(UNSUPPORTED_TOKEN)
        }
    }
}
