package com.dclass.backend.application

import com.dclass.backend.application.dto.RemainDurationResponse
import com.dclass.backend.application.dto.SwitchDepartmentResponse
import com.dclass.backend.application.dto.UpdateDepartmentRequest
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.department.DepartmentRepository
import com.dclass.backend.domain.department.getByIdOrThrow
import com.dclass.backend.domain.department.getByTitleOrThrow
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class BelongService(
    private val departmentRepository: DepartmentRepository,
    private val belongRepository: BelongRepository,
) {
    fun editDepartments(userId: Long, request: UpdateDepartmentRequest) {
        val majorDepartment = departmentRepository.getByTitleOrThrow(request.major)
        val minorDepartment = departmentRepository.getByTitleOrThrow(request.minor)

        val belong = belongRepository.getOrThrow(userId)
        belong.update(listOf(majorDepartment.id, minorDepartment.id))
    }

    fun switchDepartment(userId: Long): SwitchDepartmentResponse {
        val belong = belongRepository.getOrThrow(userId)
        belong.switch()

        return departmentRepository.getByIdOrThrow(belong.activated).title
            .let(::SwitchDepartmentResponse)
    }

    fun remain(userId: Long): RemainDurationResponse {
        val belong = belongRepository.getOrThrow(userId)
        return RemainDurationResponse(belong.remainingTime)
    }
}