package com.dclass.backend.infra

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties("aws")
data class AwsProperties(val accessKey: String, val secretKey: String)
