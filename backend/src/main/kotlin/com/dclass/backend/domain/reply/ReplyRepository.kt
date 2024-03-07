package com.dclass.backend.domain.reply

import org.springframework.data.jpa.repository.JpaRepository

interface ReplyRepository : JpaRepository<Reply, Long>, ReplyRepositorySupport {

}