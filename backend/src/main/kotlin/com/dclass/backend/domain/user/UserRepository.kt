package com.dclass.backend.domain.user

import com.dclass.backend.exception.user.UserException
import com.dclass.backend.exception.user.UserExceptionType
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.repository.findByIdOrNull

fun UserRepository.findByEmail(email: String): User? = findByInformationEmail(email)
fun UserRepository.existsByEmail(email: String): Boolean = existsByInformationEmail(email)
fun UserRepository.getOrThrow(id: Long): User = findByIdOrNull(id)
    ?: throw UserException(UserExceptionType.NOT_FOUND_USER)

fun UserRepository.getByEmailOrThrow(email: String): User = findByInformationEmail(email)
    ?: throw UserException(UserExceptionType.NOT_FOUND_USER)

interface UserRepository : JpaRepository<User, Long>, UserRepositorySupport {
    fun findByInformationEmail(email: String): User?
    fun existsByInformationEmail(email: String): Boolean
}
