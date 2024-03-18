package com.dclass.backend.application

import com.dclass.backend.application.dto.SwitchDepartmentResponse
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.department.DepartmentRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class BelongService(
    private val departmentRepository: DepartmentRepository,
    private val belongRepository: BelongRepository,
) {
    fun switchDepartment(userId: Long): SwitchDepartmentResponse {
        val belong = belongRepository.getOrThrow(userId)
        belong.switch()
        return SwitchDepartmentResponse(departmentRepository.findByIdOrNull(belong.activated)!!.title)
    }
}