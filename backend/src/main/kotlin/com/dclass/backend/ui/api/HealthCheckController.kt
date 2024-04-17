package com.dclass.backend.ui.api

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RequestMapping("/api/health-check")
@RestController
class HealthCheckController {
    @RequestMapping
    fun healthCheck(): ResponseEntity<String> {
        return ResponseEntity.ok("Service is up and running!")
    }
}