package com.dclass.backend.common

import com.dclass.backend.domain.blacklist.Blacklist
import com.dclass.backend.domain.post.Post
import jakarta.transaction.Transactional
import org.springframework.jdbc.core.BatchPreparedStatementSetter
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.stereotype.Repository
import java.sql.PreparedStatement

@Repository
class BulkInsertRepository(
    private val jdbcTemplate: JdbcTemplate
) {

    @Transactional
    fun bulkInsert(values: List<Post>): Long? {
        val sql =
            """INSERT INTO post (community_id, content, created_date_time, deleted, is_anonymous, is_question, modified_date_time, comment_reply_count, like_count, scrap_count, title, user_id, version,id)
            |VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""".trimMargin()
        jdbcTemplate.batchUpdate(
            sql,
            object : BatchPreparedStatementSetter {
                override fun setValues(ps: PreparedStatement, i: Int) {
                    val post = values[i]
                    ps.setLong(1, post.communityId)
                    ps.setString(2, post.content)
                    ps.setObject(3, post.createdDateTime)
                    ps.setBoolean(4, false)
                    ps.setBoolean(5, post.isAnonymous)
                    ps.setBoolean(6, post.isQuestion)
                    ps.setObject(7, post.modifiedDateTime)
                    ps.setInt(8, post.postCount.commentReplyCount)
                    ps.setInt(9, post.postCount.likeCount)
                    ps.setInt(10, post.postCount.scrapCount)
                    ps.setString(11, post.title)
                    ps.setLong(12, post.userId)
                    ps.setLong(13, post.version)
                    ps.setLong(14, post.id)
                }

                override fun getBatchSize(): Int {
                    return values.size
                }
            },
        )
        return jdbcTemplate.queryForObject("SELECT LAST_INSERT_ID()", Long::class.java)!!
    }

    @Transactional
    fun bulkBlacklistInsert(values: List<Blacklist>): Long? {
        val sql =
            """INSERT INTO blacklist (deleted, id, invalid_refresh_token)
            |VALUES (?, ?, ?)""".trimMargin()
        jdbcTemplate.batchUpdate(
            sql,
            object : BatchPreparedStatementSetter {
                override fun setValues(ps: PreparedStatement, i: Int) {
                    val blacklists = values[i]
                    ps.setBoolean(1, false)
                    ps.setLong(2, blacklists.id)
                    ps.setString(3, blacklists.invalidRefreshToken)
                }

                override fun getBatchSize(): Int {
                    return values.size
                }
            },
        )
        return jdbcTemplate.queryForObject("SELECT LAST_INSERT_ID()", Long::class.java)!!
    }
}
