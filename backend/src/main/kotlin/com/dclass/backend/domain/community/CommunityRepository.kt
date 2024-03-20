package com.dclass.backend.domain.community

import com.dclass.backend.exception.community.CommunityException
import com.dclass.backend.exception.community.CommunityExceptionType.NOT_FOUND_COMMUNITY
import org.springframework.data.jpa.repository.JpaRepository

fun CommunityRepository.getByTitleOrThrow(title: String): Community {
    return findByTitle(title) ?: throw CommunityException(NOT_FOUND_COMMUNITY)
}

fun CommunityRepository.getByIdOrThrow(id: Long): Community {
    return findById(id).orElseThrow { CommunityException(NOT_FOUND_COMMUNITY) }
}

interface CommunityRepository : JpaRepository<Community, Long> {
    fun findByDepartmentIdIn(departmentIds: List<Long>): List<Community>
    fun findByDepartmentId(departmentId: Long): List<Community>
    fun findByTitle(title: String): Community?
}