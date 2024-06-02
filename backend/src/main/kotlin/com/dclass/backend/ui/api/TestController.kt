package com.dclass.backend.ui.api

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RequestMapping("/predict")
@RestController
class TestController {

    @PostMapping
    fun predict(@RequestBody request: TestRequest): ResponseEntity<TestResponse> {
        return ResponseEntity.ok(TestResponse())
    }
}

data class TestResponse(
    val profanity: Boolean = false,
)

data class TestRequest(
    val message: String = "",
)
