package com.dclass.backend.application

import org.springframework.stereotype.Component
import java.util.*

@Component
class UUIDBasedPasswordGenerator: PasswordGenerator {
    override fun generate(): String {
        return UUID.randomUUID().toString()
    }
}