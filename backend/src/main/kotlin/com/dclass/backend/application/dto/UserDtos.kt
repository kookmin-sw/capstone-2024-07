package com.dclass.backend.application.dto

import com.dclass.backend.domain.belong.Belong
import com.dclass.backend.domain.user.Password
import com.dclass.backend.domain.user.University
import com.dclass.backend.domain.user.User
import io.swagger.v3.oas.annotations.media.Schema
import jakarta.validation.constraints.Email
import jakarta.validation.constraints.Pattern

data class UserResponse(
    @Schema(
        description = "유저의 고유 식별자",
        example = "1"
    )
    val id: Long,

    @Schema(
        description = "유저의 이름",
        example = "쿠민이"
    )
    val name: String,

    @Schema(
        description = "유저의 대학교 이메일",
        example = "test@kookmin.ac.kr"
    )
    val email: String,

    @Schema(
        description = "유저의 닉네임",
        example = "ku-mini"
    )
    val nickname: String,

    @Schema(
        description = "유저의 대학교 이름",
        example = "국민대학교"
    )
    val universityName: String,
) {
    constructor(user: User) : this(
        user.id,
        user.name,
        user.email,
        user.nickname,
        user.universityName
    )
}


data class UserResponseWithDepartment(
    val userResponse: UserResponse,

    @Schema(
        description = "유저의 소속 학과들의 고유 식별자 리스트",
        example = "[1, 2]"
    )
    val departmentIds: List<Long>,
) {
    constructor(user: User, belong: Belong) : this(
        UserResponse(user),
        belong.departmentIds
    )
}


data class UserResponseWithDepartmentNames(
    @Schema(
        description = "유저의 고유 식별자",
        example = "1"
    )
    val id: Long,

    @Schema(
        description = "유저의 이름",
        example = "쿠민이"
    )
    val name: String,

    @Schema(
        description = "유저의 대학교 이메일",
        example = "test@kookmin.ac.kr"
    )
    val email: String,

    @Schema(
        description = "유저의 닉네임",
        example = "ku-mini"
    )
    val nickname: String,

    @Schema(
        description = "유저의 대학교 이름",
        example = "국민대학교"
    )
    val universityName: String,
    @Schema(
        description = "유저의 전공 학과 이름",
        example = "컴퓨터공학과"
    )
    val major: String,

    @Schema(
        description = "유저의 부전공 학과 이름",
        example = "소프트웨어학과"
    )
    val minor: String = "",
) {
    constructor(user: User, major: String, minor: String) : this(
        user.id,
        user.name,
        user.email,
        user.nickname,
        user.universityName,
        major = major,
        minor = minor,
    )

    constructor(user: User, major: String) : this(
        user.id,
        user.name,
        user.email,
        user.nickname,
        user.universityName,
        major = major,
    )
}

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

data class ResetPasswordRequest(
    @field:Pattern(regexp = "[가-힣]{1,30}", message = "올바른 형식의 이름이어야 합니다")
    val name: String,

    @field:Email
    val email: String,
)

data class EditPasswordRequest(
    val oldPassword: Password,
    val password: Password,
    val confirmPassword: Password
)

data class LoginUserResponse(
    val accessToken: String,
    val refreshToken: String
)