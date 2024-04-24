package com.dclass.backend.security

import com.dclass.backend.exception.token.TokenException
import com.dclass.backend.exception.token.TokenExceptionType.*
import io.jsonwebtoken.*
import io.jsonwebtoken.security.Keys
import io.jsonwebtoken.security.SignatureException
import org.springframework.stereotype.Component
import java.util.*
import javax.crypto.SecretKey

@Component
class JwtTokenProvider(
    private val signingKey: SecretKey = Keys.secretKeyFor(SignatureAlgorithm.HS256),
) {
    companion object {
        const val ACCESS_TOKEN_EXPIRATION_MILLISECONDS: Long = 1000 * 60 * 2 * 1 // 1시간
        const val REFRESH_TOKEN_EXPIRATION_MILLISECONDS: Long = 1000 * 60 * 60 * 24 * 14 // 2주
    }

    fun createAccessToken(payload: String): String {
        return createToken(payload, ACCESS_TOKEN_EXPIRATION_MILLISECONDS)
    }

    fun createRefreshToken(payload: String): String {
        return createToken(payload, REFRESH_TOKEN_EXPIRATION_MILLISECONDS)
    }

    fun createToken(payload: String, validity: Long): String {
        return try {
            Jwts.builder()
                .setSubject(payload)
                .setExpiration(Date(System.currentTimeMillis() + validity))
                .signWith(signingKey)
                .compact()
        } catch (e: IllegalArgumentException) {
            throw TokenException(CANNOT_CREATE_TOKEN)
        }
    }

    fun getSubject(token: String): String {
        return getClaimsJws(token)
            .body
            .subject
    }

    fun validateToken(token: String): Unit {
        try {
            getClaimsJws(token)
        } catch (e: SignatureException) {
            throw TokenException(INVALID_TOKEN)
        } catch (e: MalformedJwtException) {
            throw TokenException(WRONG_TOKEN_TYPE)
        } catch (e: ExpiredJwtException) {
            throw TokenException(EXPIRED_TOKEN)
        } catch (e: UnsupportedJwtException) {
            throw TokenException(UNSUPPORTED_TOKEN)
        } catch (e: IllegalArgumentException) {
            throw TokenException(NOT_FOUND_TOKEN)
        }
    }

    private fun getClaimsJws(token: String) = Jwts.parserBuilder()
        .setSigningKey(signingKey.encoded)
        .build()
        .parseClaimsJws(token)
}