package com.dclass.backend.domain.community

import org.springframework.data.jpa.repository.JpaRepository

interface CommunityRepository : JpaRepository<Community, Long> {
    fun findByDepartmentIdIn(departmentIds: List<Long>): List<Community>
    fun findByDepartmentId(departmentId: Long): List<Community>
}