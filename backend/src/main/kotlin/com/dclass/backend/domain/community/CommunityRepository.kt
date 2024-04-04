package com.dclass.backend.domain.community

import com.dclass.backend.exception.community.CommunityException
import com.dclass.backend.exception.community.CommunityExceptionType.NOT_FOUND_COMMUNITY
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.repository.findByIdOrNull


fun CommunityRepository.findByIdOrThrow(id: Long): Community {
    return findByIdOrNull(id) ?: throw CommunityException(NOT_FOUND_COMMUNITY)
}

interface CommunityRepository : JpaRepository<Community, Long> {
    fun findByDepartmentIdIn(departmentIds: List<Long>): List<Community>
    fun findByDepartmentId(departmentId: Long): List<Community>
    fun findByTitle(title: String): Community?
    fun findByDepartmentIdAndTitle(departmentId: Long, title: String): Community?
}