package com.dclass.backend.application

import com.dclass.backend.application.dto.EditPasswordRequest
import com.dclass.backend.application.dto.ResetPasswordRequest
import com.dclass.backend.application.dto.UserResponseWithDepartmentNames
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.department.DepartmentRepository
import com.dclass.backend.domain.user.User
import com.dclass.backend.domain.user.UserRepository
import com.dclass.backend.domain.user.findByEmail
import com.dclass.backend.domain.user.getOrThrow
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional


@Transactional
@Service
class UserService(
    private val userRepository: UserRepository,
    private val passwordGenerator: PasswordGenerator,
    private val departmentRepository: DepartmentRepository,
    private val belongRepository: BelongRepository,
) {
    fun getByEmail(email: String): User {
        return userRepository.findByEmail(email)
            ?: throw IllegalArgumentException("회원이 존재하지 않습니다. email: $email")
    }

    fun resetPassword(request: ResetPasswordRequest) {
        val user = getByEmail(request.email)
        user.resetPassword(request.name, passwordGenerator.generate())
        userRepository.save(user)
    }

    fun editPassword(id: Long, request: EditPasswordRequest) {
        require(request.password == request.confirmPassword) { "새 비밀번호가 일치하지 않습니다." }
        userRepository.getOrThrow(id).changePassword(request.oldPassword, request.password)
    }

    fun getInformation(id: Long): UserResponseWithDepartmentNames {
        val user = userRepository.findByIdOrNull(id)
            ?: throw IllegalArgumentException("회원이 존재하지 않습니다. id: $id")

        val belong = belongRepository.getOrThrow(id)

        val departments = departmentRepository.findAllById(belong.departmentIds)

        val groupby = belong.departmentIds.associateWith { departmentId ->
            departments.find { it.id == departmentId }
                ?: throw IllegalArgumentException("학과가 존재하지 않습니다: $departmentId")
        }

        return UserResponseWithDepartmentNames(
            user,
            groupby[belong.major]!!.title,
            if (departments.size == 2) groupby[belong.minor]!!.title else ""
        )
    }

    fun switchDepartment(id: Long) {
        val belong = belongRepository.getOrThrow(id)
        belong.switch()
    }

}
