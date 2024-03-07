package com.dclass.backend.security

import com.dclass.backend.application.UserService
import com.dclass.backend.domain.user.User
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
    private val userService: UserService
) : HandlerMethodArgumentResolver {

    override fun supportsParameter(parameter: MethodParameter): Boolean {
        return parameter.hasParameterAnnotation(LoginUser::class.java)
    }

    override fun resolveArgument(
        parameter: MethodParameter,
        mavContainer: ModelAndViewContainer?,
        webRequest: NativeWebRequest,
        binderFactory: WebDataBinderFactory?
    ): User {
        val token = extractBearerToken(webRequest)
        if (!jwtTokenProvider.isValidToken(token)) {
            throw LoginFailedException()
        }
        val userEmail = jwtTokenProvider.getSubject(token)
        return userService.getByEmail(userEmail)
    }

    private fun extractBearerToken(request: NativeWebRequest): String {
        val authorization =
            request.getHeader(HttpHeaders.AUTHORIZATION) ?: throw LoginFailedException()
        val (tokenType, token) = splitToTokenFormat(authorization)
        if (tokenType != BEARER) {
            throw LoginFailedException()
        }
        return token
    }

    private fun splitToTokenFormat(authorization: String): Pair<String, String> {
        return try {
            val tokenFormat = authorization.split(" ")
            tokenFormat[0] to tokenFormat[1]
        } catch (e: IndexOutOfBoundsException) {
            throw LoginFailedException()
        }
    }
}