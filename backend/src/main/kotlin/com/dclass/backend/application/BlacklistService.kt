package com.dclass.backend.application

import com.dclass.backend.application.dto.LoginUserResponse
import com.dclass.backend.domain.blacklist.Blacklist
import com.dclass.backend.domain.blacklist.BlacklistRepository
import com.dclass.backend.exception.blacklist.BlacklistException
import com.dclass.backend.exception.blacklist.BlacklistExceptionType
import com.dclass.backend.exception.blacklist.BlacklistExceptionType.ALREADY_LOGOUT
import com.dclass.backend.exception.token.TokenException
import com.dclass.backend.exception.token.TokenExceptionType.TOKEN_NOT_FOUND_IN_BLACKLIST
import com.dclass.backend.security.JwtTokenProvider
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional


@Transactional
@Service
class BlacklistService(
    private val blacklistRepository: BlacklistRepository,
    private val jwtTokenProvider: JwtTokenProvider,
) {
    fun reissueToken(refreshToken: String): LoginUserResponse {
        jwtTokenProvider.isValidToken(refreshToken)
        blacklistRepository.findByInvalidRefreshToken(refreshToken)
            ?.let { throw BlacklistException(ALREADY_LOGOUT) }
            ?: blacklistRepository.save(Blacklist(refreshToken))

        val email = jwtTokenProvider.getSubject(refreshToken)
        return LoginUserResponse(
            jwtTokenProvider.createAccessToken(email),
            jwtTokenProvider.createRefreshToken(email)
        )
    }
}