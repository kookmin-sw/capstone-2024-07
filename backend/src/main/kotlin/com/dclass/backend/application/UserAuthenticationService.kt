package com.dclass.backend.application

import com.dclass.backend.application.dto.AuthenticateUserRequest
import com.dclass.backend.application.dto.LoginUserResponse
import com.dclass.backend.application.dto.RegisterUserRequest
import com.dclass.backend.domain.authenticationcode.AuthenticationCode
import com.dclass.backend.domain.authenticationcode.AuthenticationCodeRepository
import com.dclass.backend.domain.authenticationcode.getLastByEmail
import com.dclass.backend.domain.belong.Belong
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.department.DepartmentRepository
import com.dclass.backend.domain.department.getByTitleOrThrow
import com.dclass.backend.domain.user.UniversityRepository
import com.dclass.backend.domain.user.UserRepository
import com.dclass.backend.domain.user.existsByEmail
import com.dclass.backend.domain.user.getByEmailOrThrow
import com.dclass.backend.exception.university.UniversityException
import com.dclass.backend.exception.university.UniversityExceptionType.NOT_FOUND_UNIVERSITY
import com.dclass.backend.exception.user.UserException
import com.dclass.backend.exception.user.UserExceptionType.ALREADY_EXIST_USER
import com.dclass.backend.exception.user.UserExceptionType.RESIGNED_USER
import com.dclass.backend.security.JwtTokenProvider
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class UserAuthenticationService(
    private val userRepository: UserRepository,
    private val authenticationCodeRepository: AuthenticationCodeRepository,
    private val universityRepository: UniversityRepository,
    private val belongRepository: BelongRepository,
    private val departmentRepository: DepartmentRepository,
    private val jwtTokenProvider: JwtTokenProvider,
) {
    fun generateTokenByRegister(request: RegisterUserRequest): LoginUserResponse {
        require(request.password == request.confirmPassword) { "비밀번호가 일치하지 않습니다." }

        if (userRepository.existsByEmail(request.email)) {
            throw UserException(ALREADY_EXIST_USER)
        }

        authenticationCodeRepository.getLastByEmail(request.email)
            .validate(request.authenticationCode)

        val univ = universityRepository.findByEmailSuffix(getEmailSuffix(request.email))
        val user = userRepository.save(request.toEntity(univ))

        val majorDepartment = departmentRepository.getByTitleOrThrow(request.major)
        val minorDepartment = departmentRepository.getByTitleOrThrow(request.minor)

        belongRepository.save(
            Belong(
                user.id,
                listOf(majorDepartment.id, minorDepartment.id),
            )
        )

        return LoginUserResponse(
            jwtTokenProvider.createAccessToken(user.email),
            jwtTokenProvider.createRefreshToken(user.email)
        )
    }

    fun generateTokenByLogin(request: AuthenticateUserRequest): LoginUserResponse {
        val user = userRepository.getByEmailOrThrow(request.email)
        if(user.isDeleted()) throw UserException(RESIGNED_USER)

        user.authenticate(request.password)

        return LoginUserResponse(
            jwtTokenProvider.createAccessToken(user.email),
            jwtTokenProvider.createRefreshToken(user.email)
        )
    }

    fun generateAuthenticationCode(email: String): String {
        if (userRepository.existsByEmail(email)) {
            throw UserException(ALREADY_EXIST_USER)
        }
        if (!universityRepository.existsByEmailSuffix(getEmailSuffix(email))) {
            throw UniversityException(NOT_FOUND_UNIVERSITY)
        }

        val authenticationCode = authenticationCodeRepository.save(AuthenticationCode(email))
        return authenticationCode.code
    }

    fun authenticateEmail(email: String, code: String) {
        val authenticationCode = authenticationCodeRepository.getLastByEmail(email)
        authenticationCode.authenticate(code)
    }

    private fun getEmailSuffix(email: String): String {
        return email.substringAfterLast("@")
    }
}