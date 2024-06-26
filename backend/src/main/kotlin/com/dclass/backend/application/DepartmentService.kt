package com.dclass.backend.application

import com.dclass.backend.application.dto.DepartmentDTO
import com.dclass.backend.application.dto.DepartmentGroupDTO
import com.dclass.backend.domain.department.DepartmentDetail.Companion.findByTitle
import com.dclass.backend.domain.department.DepartmentGroup.Companion.findByDepartmentDetail
import com.dclass.backend.domain.department.DepartmentRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class DepartmentService(
    private val departmentRepository: DepartmentRepository,
) {
    fun readAll(): List<DepartmentGroupDTO> {
        val groupedDepartments = departmentRepository.findAll()
            .groupBy { findByDepartmentDetail(findByTitle(it.title)).category }

        return groupedDepartments.map {
            DepartmentGroupDTO(it.key, it.value.map { department -> DepartmentDTO(department.id, department.title) })
        }
    }
}
