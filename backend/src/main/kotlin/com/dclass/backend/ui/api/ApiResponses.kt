package com.dclass.backend.ui.api

data class ApiResponses<T>(
    val message: String? = "",
    val body: T? = null
) {
    companion object {
        fun error(message: String?): ApiResponses<Unit> = ApiResponses(message = message)

        fun <T> success(body: T?): ApiResponses<T> = ApiResponses(body = body)
    }
}