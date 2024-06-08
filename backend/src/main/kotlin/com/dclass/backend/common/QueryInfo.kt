package com.dclass.backend.common

data class QueryInfo(
    var count: Int = 0,
    var time: Long = 0L,
) {

    fun increaseCount() {
        count++
    }
}
