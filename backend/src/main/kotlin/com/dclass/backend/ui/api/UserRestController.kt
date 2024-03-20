package com.dclass.backend.ui.api

import com.dclass.backend.application.BlacklistService
import com.dclass.backend.application.UserAuthenticationService
import com.dclass.backend.application.UserService
import com.dclass.backend.application.dto.*
import com.dclass.backend.application.mail.MailService
import com.dclass.backend.config.ACCESS_TOKEN_SECURITY_SCHEME_KEY
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.responses.ApiResponse
import io.swagger.v3.oas.annotations.security.SecurityRequirement
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@Tag(name = "User", description = "유저 관련 API 명세")
@RequestMapping("/api/users")
@RestController
class UserRestController(
    private val userService: UserService,
    private val userAuthenticationService: UserAuthenticationService,
    private val blacklistService: BlacklistService,
    private val mailService: MailService
) {

    @Operation(summary = "회원가입 API", description = "이메일 인증 후 회원가입을 진행합니다")
    @ApiResponse(responseCode = "200", description = "회원가입 성공")
    @PostMapping("/register")
    fun generateToken(@RequestBody @Valid request: RegisterUserRequest): ResponseEntity<LoginUserResponse> {
        val token = userAuthenticationService.generateTokenByRegister(request)
        return ResponseEntity.ok(token)
    }

    @Operation(summary = "로그인 API", description = "로그인을 진행합니다")
    @ApiResponse(responseCode = "200", description = "로그인 성공")
    @PostMapping("/login")
    fun generateToken(@RequestBody @Valid request: AuthenticateUserRequest): ResponseEntity<LoginUserResponse> {
        val token = userAuthenticationService.generateTokenByLogin(request)
        return ResponseEntity.ok(token)
    }

    @Operation(summary = "토큰 재발급 API", description = "리프레시 토큰을 이용하여 토큰을 재발급합니다")
    @ApiResponse(responseCode = "200", description = "토큰 재발급 성공")
    @PostMapping("/reissue-token")
    fun generateToken(@RequestParam refreshToken: String): ResponseEntity<LoginUserResponse> {
        val token = blacklistService.reissueToken(refreshToken)
        return ResponseEntity.ok(token)
    }

    @Operation(summary = "비밀번호 재설정 API", description = "비밀번호를 재설정한 후 변경된 비밀번호를 이메일로 전송합니다")
    @ApiResponse(responseCode = "204", description = "비밀번호 재설정 성공")
    @PostMapping("/reset-password")
    fun resetPassword(@RequestBody @Valid request: ResetPasswordRequest): ResponseEntity<Unit> {
        userService.resetPassword(request)
        return ResponseEntity.noContent().build()
    }

    @Operation(summary = "비밀번호 변경 API", description = "비밀번호를 변경합니다")
    @ApiResponse(responseCode = "204", description = "비밀번호 변경 성공")
    @SecurityRequirement(name = ACCESS_TOKEN_SECURITY_SCHEME_KEY)
    @PostMapping("/edit-password")
    fun editPassword(
        @RequestBody @Valid request: EditPasswordRequest,
        @LoginUser user: User
    ): ResponseEntity<Unit> {
        userService.editPassword(user.id, request)
        return ResponseEntity.noContent().build()
    }

    @Operation(summary = "이메일 인증코드 발급 API", description = "이메일로 인증코드를 발급합니다")
    @ApiResponse(responseCode = "204", description = "이메일 인증코드 발급 성공")
    @PostMapping("/authentication-code")
    fun generateAuthenticationCode(
        @RequestParam email: String
    ): ResponseEntity<Unit> {
        val authenticationCode = userAuthenticationService
            .generateAuthenticationCode(email)
        mailService.sendAuthenticationCodeMail(email, authenticationCode)
        return ResponseEntity.noContent().build()
    }

    @Operation(summary = "이메일 인증 API", description = "이메일을 인증합니다")
    @ApiResponse(responseCode = "204", description = "이메일 인증 성공")
    @PostMapping("/authenticate-email")
    fun authenticateEmail(
        @RequestParam email: String,
        @RequestParam authenticationCode: String
    ): ResponseEntity<Unit> {
        userAuthenticationService.authenticateEmail(email, authenticationCode)
        return ResponseEntity.noContent().build()
    }

    @Operation(summary = "내 정보 조회 API", description = "내 정보를 조회합니다")
    @ApiResponse(responseCode = "200", description = "내 정보 조회 성공")
    @SecurityRequirement(name = ACCESS_TOKEN_SECURITY_SCHEME_KEY)
    @GetMapping("/me")
    fun getMyInformation(
        @LoginUser user: User
    ): ResponseEntity<UserResponseWithDepartmentNames> {
        val response = userService.getInformation(user.id)
        return ResponseEntity.ok(response)
    }


    @Operation(summary = "닉네임 변경 API", description = "닉네임을 변경합니다")
    @ApiResponse(responseCode = "204", description = "닉네임 변경 성공")
    @PutMapping("/change-nickname")
    fun changeNickname(
        @RequestBody @Valid request: UpdateNicknameRequest,
        @LoginUser user: User
    ): ResponseEntity<Unit> {
        userService.editNickname(user.id, request)
        return ResponseEntity.noContent().build()
    }
}