package com.dclass.backend.ui.api

import com.dclass.backend.application.BlacklistService
import com.dclass.backend.application.UserAuthenticationService
import com.dclass.backend.application.UserService
import com.dclass.backend.application.dto.*
import com.dclass.backend.application.mail.MailService
import com.dclass.backend.domain.user.User
import com.dclass.backend.security.LoginUser
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RequestMapping("/api/users")
@RestController
class UserRestController(
    private val userService: UserService,
    private val userAuthenticationService: UserAuthenticationService,
    private val blacklistService: BlacklistService,
    private val mailService: MailService
) {

    @PostMapping("/register")
    fun generateToken(@RequestBody @Valid request: RegisterUserRequest): ResponseEntity<ApiResponse<LoginUserResponse>> {
        val token = userAuthenticationService.generateTokenByRegister(request)
        return ResponseEntity.ok(ApiResponse.success(token))
    }

    @PostMapping("/login")
    fun generateToken(@RequestBody @Valid request: AuthenticateUserRequest): ResponseEntity<ApiResponse<LoginUserResponse>> {
        val token = userAuthenticationService.generateTokenByLogin(request)
        return ResponseEntity.ok(ApiResponse.success(token))
    }

    @PostMapping("/reissue-token")
    fun generateToken(@RequestParam refreshToken: String): ResponseEntity<ApiResponse<LoginUserResponse>> {
        val token = blacklistService.reissueToken(refreshToken)
        return ResponseEntity.ok(ApiResponse.success(token))
    }

    @PostMapping("/reset-password")
    fun resetPassword(@RequestBody @Valid request: ResetPasswordRequest): ResponseEntity<Unit> {
        userService.resetPassword(request)
        return ResponseEntity.noContent().build()
    }

    @PostMapping("/edit-password")
    fun editPassword(
        @RequestBody @Valid request: EditPasswordRequest,
        @LoginUser user: User
    ): ResponseEntity<Unit> {
        userService.editPassword(user.id, request)
        return ResponseEntity.noContent().build()
    }

    @PostMapping("/authentication-code")
    fun generateAuthenticationCode(
        @RequestParam email: String
    ): ResponseEntity<Unit> {
        val authenticationCode = userAuthenticationService
            .generateAuthenticationCode(email)
        mailService.sendAuthenticationCodeMail(email, authenticationCode)
        return ResponseEntity.noContent().build()
    }

    @PostMapping("/authenticate-email")
    fun authenticateEmail(
        @RequestParam email: String,
        @RequestParam authenticationCode: String
    ): ResponseEntity<Unit> {
        userAuthenticationService.authenticateEmail(email, authenticationCode)
        return ResponseEntity.noContent().build()
    }

    @GetMapping("/me")
    fun getMyInformation(
        @LoginUser user: User
    ): ResponseEntity<ApiResponse<UserResponse>> {
        val response = userService.getInformation(user.id)
        return ResponseEntity.ok(ApiResponse.success(response))
    }

}