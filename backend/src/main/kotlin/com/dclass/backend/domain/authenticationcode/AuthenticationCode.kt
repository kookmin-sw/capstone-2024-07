package com.dclass.backend.domain.authenticationcode

import com.dclass.backend.exception.authenticationcode.AuthenticationCodeException
import com.dclass.backend.exception.authenticationcode.AuthenticationCodeExceptionType.*
import com.dclass.support.domain.BaseEntity
import jakarta.persistence.Column
import jakarta.persistence.Entity
import org.hibernate.annotations.SQLDelete
import org.hibernate.annotations.SQLRestriction
import java.time.Duration
import java.time.LocalDateTime
import java.util.*

@SQLDelete(sql = "update authentication_code set deleted = true where id = ?")
@SQLRestriction("deleted = false")
@Entity
class AuthenticationCode(
    @Column(nullable = false)
    val email: String,

    @Column(nullable = false, columnDefinition = "char(6)")
    val code: String = UUID.randomUUID().toString().take(6),

    @Column(nullable = false)
    var authenticated: Boolean = false,

    @Column(nullable = false)
    val createdDateTime: LocalDateTime = LocalDateTime.now(),
) : BaseEntity() {

    @Column(nullable = false)
    private var deleted: Boolean = false

    private val expiryDateTime: LocalDateTime
        get() = createdDateTime + EXPIRY_MINUTE_TIME

    fun authenticate(code: String) {
        if (this.code != code) {
            throw AuthenticationCodeException(NOT_EQUAL_CODE)
        }
        if (authenticated) {
            throw AuthenticationCodeException(ALREADY_VERIFIED)
        }
        if (expiryDateTime < LocalDateTime.now()) {
            throw AuthenticationCodeException(EXPIRED_CODE)
        }
        authenticated = true
    }

    fun validate(code: String) {
        if (this.code != code) {
            throw AuthenticationCodeException(NOT_EQUAL_CODE)
        }
        if (!authenticated) {
            throw AuthenticationCodeException(NOT_VERIFIED)
        }
    }

    companion object {
        private val EXPIRY_MINUTE_TIME: Duration = Duration.ofMinutes(10L)
    }
}
