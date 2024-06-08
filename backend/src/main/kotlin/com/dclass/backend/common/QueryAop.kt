package com.dclass.backend.common

import com.dclass.support.util.logger
import org.aspectj.lang.ProceedingJoinPoint
import org.aspectj.lang.annotation.After
import org.aspectj.lang.annotation.Around
import org.aspectj.lang.annotation.Aspect
import org.springframework.stereotype.Component
import org.springframework.web.context.request.RequestContextHolder
import org.springframework.web.context.request.ServletRequestAttributes
import kotlin.concurrent.getOrSet

@Aspect
@Component
class QueryAop {
    private val log = logger()
    private val queryInfoStorage = ThreadLocal<QueryInfo>()

    @Around("execution( * javax.sql.DataSource.getConnection())")
    fun getProxyConnection(joinPoint: ProceedingJoinPoint): Any {
        val connection = joinPoint.proceed()
        val queryInfo = queryInfoStorage.getOrSet { QueryInfo() }
        return ConnectionProxyHandler(connection, queryInfo).getProxy()
    }

    @After("within(@org.springframework.web.bind.annotation.RestController *)")
    fun logQueryInfo() {
        val attributes = RequestContextHolder.getRequestAttributes() as? ServletRequestAttributes
        val request = attributes?.request
        request?.let {
            val queryInfo = queryInfoStorage.getOrSet { QueryInfo() }
            log.info(
                "METHOD: ${request.method}," +
                    " URI: ${request.requestURI}," +
                    " QUERY_COUNT: ${queryInfo.count}," +
                    " QUERY_TIME: ${queryInfo.time}ms",
            )
        }
        queryInfoStorage.remove()
    }
}
