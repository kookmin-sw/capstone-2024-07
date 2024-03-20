package com.dclass.backend.application

import com.dclass.backend.application.dto.EditPasswordRequest
import com.dclass.backend.application.dto.ResetPasswordRequest
import com.dclass.backend.application.dto.UpdateNicknameRequest
import com.dclass.backend.application.dto.UserResponseWithDepartmentNames
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.department.DepartmentRepository
import com.dclass.backend.domain.user.UserRepository
import com.dclass.backend.domain.user.getByEmailOrThrow
import com.dclass.backend.domain.user.getOrThrow
import com.dclass.backend.exception.department.DepartmentException
import com.dclass.backend.exception.department.DepartmentExceptionType.NOT_FOUND_DEPARTMENT
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
    fun resetPassword(request: ResetPasswordRequest) {
        val user = userRepository.getByEmailOrThrow(request.email)
        user.resetPassword(request.name, passwordGenerator.generate())
        userRepository.save(user)
    }

    fun editPassword(id: Long, request: EditPasswordRequest) {
        require(request.password == request.confirmPassword) { "새 비밀번호가 일치하지 않습니다." }

        val user = userRepository.getOrThrow(id)
        user.changePassword(request.oldPassword, request.password)
    }

    fun editNickname(id: Long, request: UpdateNicknameRequest) {
        val user = userRepository.getOrThrow(id)

        user.changeNickname(request.nickname)
    }

    fun getInformation(id: Long): UserResponseWithDepartmentNames {
        val user = userRepository.getOrThrow(id)

        val belong = belongRepository.getOrThrow(id)

        val departments = departmentRepository.findAllById(belong.departmentIds)

        val groupBy = belong.departmentIds.associateWith { departmentId ->
            departments.find { it.id == departmentId }
                ?: throw DepartmentException(NOT_FOUND_DEPARTMENT)
        }

        return UserResponseWithDepartmentNames(
            user,
            groupBy[belong.major]!!.title,
            groupBy[belong.minor]!!.title
        )
    }
}
