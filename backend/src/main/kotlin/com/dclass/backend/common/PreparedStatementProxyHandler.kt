package com.dclass.backend.common

import jakarta.annotation.Nonnull
import jakarta.annotation.Nullable
import org.aopalliance.intercept.MethodInterceptor
import org.aopalliance.intercept.MethodInvocation
import kotlin.system.measureTimeMillis

private const val EXECUTE = "execute"

class PreparedStatementProxyHandler(
    private val queryInfo: QueryInfo,
) : MethodInterceptor {

    @Nullable
    override operator fun invoke(@Nonnull invocation: MethodInvocation): Any? {
        var result: Any?
        val executionTime = measureTimeMillis {
            result = invocation.proceed()
        }

        val method = invocation.method
        if (method.name.contains(EXECUTE)) {
            queryInfo.time = queryInfo.time.plus(executionTime)
            queryInfo.increaseCount()
        }
        return result
    }
}
