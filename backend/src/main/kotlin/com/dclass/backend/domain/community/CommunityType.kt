package com.dclass.backend.domain.community

import com.dclass.backend.exception.community.CommunityException
import com.dclass.backend.exception.community.CommunityExceptionType.NOT_FOUND_COMMUNITY


enum class CommunityType(val value: String) {
    FREE("자유게시판"), GRADUATE("대학원게시판"), JOB("취준게시판"), STUDY("스터디모집"), QUESTION("질문게시판"), PROMOTION("홍보게시판");

    companion object {
        fun from(value: String?): CommunityType? {
            if (value.isNullOrBlank()) {
                return null;
            }
            return enumValues<CommunityType>().find { it.name == value }
                ?: throw CommunityException(NOT_FOUND_COMMUNITY)
        }
    }
}