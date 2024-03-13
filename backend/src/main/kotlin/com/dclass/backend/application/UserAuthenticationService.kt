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
import com.dclass.backend.domain.department.getOrThrow
import com.dclass.backend.domain.user.*
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
        check(!userRepository.existsByEmail(request.email)) { "이미 가입된 이메일입니다." }
        authenticationCodeRepository.getLastByEmail(request.email)
            .validate(request.authenticationCode)


        val univ = universityRepository.findByEmailSuffix(getEmailSuffix(request.email))
        val user = userRepository.save(request.toEntity(univ))
        val departmentIds = mutableListOf(departmentRepository.getOrThrow(request.major).id)
        if (request.minor.isNotBlank()) {
            departmentIds.add(departmentRepository.getOrThrow(request.minor).id)
        }

        belongRepository.save(Belong(user.id, departmentIds, major = departmentIds[0]))

        return LoginUserResponse(
            jwtTokenProvider.createAccessToken(user.email),
            jwtTokenProvider.createRefreshToken(user.email)
        )
    }

    fun generateTokenByLogin(request: AuthenticateUserRequest): LoginUserResponse {
        val user = userRepository.findByEmail(request.email)
            ?: throw UnidentifiedUserException("사용자 정보가 일치하지 않습니다.")
        user.authenticate(request.password)

        return LoginUserResponse(
            jwtTokenProvider.createAccessToken(user.email),
            jwtTokenProvider.createRefreshToken(user.email)
        )
    }

    fun generateAuthenticationCode(email: String): String {
        check(!userRepository.existsByEmail(email)) { "이미 등록된 이메일입니다." }
        check(universityRepository.existsByEmailSuffix(getEmailSuffix(email))) { "이메일이 등록되지 않은 대학교입니다." }
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