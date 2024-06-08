package com.dclass.backend.common

import org.aopalliance.intercept.MethodInterceptor
import org.aopalliance.intercept.MethodInvocation
import org.springframework.aop.framework.ProxyFactory

private const val HIKARY_PROXY_CONNECTION = "HikariProxyConnection"
private const val PREPARED_STATEMENT = "prepareStatement"

class ConnectionProxyHandler(
    private val connection: Any,
    private val queryInfo: QueryInfo,
) : MethodInterceptor {

    override fun invoke(invocation: MethodInvocation): Any? {
        val result = invocation.proceed()
        if (result != null && isPreparedStatement(invocation)) {
            val proxyFactory = ProxyFactory(result)
            proxyFactory.addAdvice(PreparedStatementProxyHandler(queryInfo))
            return proxyFactory.proxy
        }
        return result
    }

    private fun isPreparedStatement(invocation: MethodInvocation): Boolean {
        val targetObject = invocation.`this` ?: return false
        val targetClass: Class<*> = targetObject.javaClass
        val targetMethod = invocation.method
        return targetClass.name.contains(HIKARY_PROXY_CONNECTION) && targetMethod.name == PREPARED_STATEMENT
    }

    fun getProxy(): Any {
        val proxyFactory = ProxyFactory(connection)
        proxyFactory.addAdvice(this)
        return proxyFactory.proxy
    }
}
