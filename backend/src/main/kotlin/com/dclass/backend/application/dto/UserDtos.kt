package com.dclass.backend.application.dto

import com.dclass.backend.domain.user.Password
import com.dclass.backend.domain.user.University
import com.dclass.backend.domain.user.User
import jakarta.validation.constraints.Email
import jakarta.validation.constraints.Pattern


data class RegisterUserRequest(
    @field:Pattern(regexp = "[가-힣]{1,30}", message = "올바른 형식의 이름이어야 합니다")
    val name: String,

    @field:Email
    val email: String,

    val nickname: String,
    val password: String,
    val confirmPassword: String,
    val authenticationCode: String
) {
    fun toEntity(univ: University): User {
        return User(name, email, nickname, password, univ)
    }
}

data class AuthenticateUserRequest(
    @field:Email
    val email: String,
    val password: Password
)

data class LoginUserResponse(
    val accessToken: String,
    val refreshToken: String
)