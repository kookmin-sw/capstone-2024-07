package com.dclass.backend.common

import com.dclass.support.util.logger
import org.aspectj.lang.annotation.After
import org.aspectj.lang.annotation.Aspect
import org.springframework.stereotype.Component
import org.springframework.web.context.request.RequestContextHolder
import org.springframework.web.context.request.ServletRequestAttributes

@Aspect
@Component
class QueryAop {
    private val log = logger()

    @After("within(@org.springframework.web.bind.annotation.RestController *)")
    fun logQueryInfo() {
        val attributes = RequestContextHolder.getRequestAttributes() as? ServletRequestAttributes
        val request = attributes?.request
        request?.let {
            log.info("METHOD: ${request.method}, URI: ${request.requestURI}")
        }
    }
}
