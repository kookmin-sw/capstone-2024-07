package com.dclass.backend.ui.api

import com.dclass.backend.application.DepartmentService
import com.dclass.backend.application.dto.DepartmentGroupDTO
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RequestMapping("/api/departments")
@RestController
class DepartmentController(
    private val departmentService: DepartmentService,
) {
    @GetMapping
    fun readAll(): ResponseEntity<List<DepartmentGroupDTO>> {
        return ResponseEntity.ok(departmentService.readAll())
    }
}
