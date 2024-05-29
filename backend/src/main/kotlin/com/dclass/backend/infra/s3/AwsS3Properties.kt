package com.dclass.backend.infra.s3

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties("aws.s3")
data class AwsS3Properties(val bucket: String, val region: String)
