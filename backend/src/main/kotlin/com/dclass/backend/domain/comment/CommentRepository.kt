package com.dclass.backend.domain.comment

import org.springframework.data.jpa.repository.JpaRepository

interface CommentRepository : JpaRepository<Comment, Long>, CommentRepositorySupport {

}