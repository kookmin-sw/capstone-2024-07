package com.dclass.backend

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.ConfigurationPropertiesScan
import org.springframework.boot.runApplication

@SpringBootApplication
@ConfigurationPropertiesScan
class BackendApplication

/* rebase */
fun main(args: Array<String>) {
	runApplication<BackendApplication>(*args)
}
