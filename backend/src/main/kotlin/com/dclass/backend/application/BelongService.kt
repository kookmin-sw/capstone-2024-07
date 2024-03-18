package com.dclass.backend.application

import com.dclass.backend.application.dto.SwitchDepartmentResponse
import com.dclass.backend.application.dto.UpdateDepartmentRequest
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.department.DepartmentRepository
import com.dclass.backend.domain.department.getByTitleOrThrow
import org.springframework.data.repository.findByIdOrNull
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

        belongRepository.getOrThrow(userId).update(listOf(majorDepartment.id, minorDepartment.id))
    }

    fun switchDepartment(userId: Long): SwitchDepartmentResponse {
        val belong = belongRepository.getOrThrow(userId)
        belong.switch()
        return SwitchDepartmentResponse(departmentRepository.findByIdOrNull(belong.activated)!!.title)
    }
}