package com.dclass.backend.infra

import aws.sdk.kotlin.runtime.auth.credentials.StaticCredentialsProvider
import aws.sdk.kotlin.services.ses.SesClient
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration


@Configuration
class SesConfiguration(private val awsProperties: AwsProperties) {
    @Bean(destroyMethod = "close")
    fun sesClient() = SesClient {
        region = "ap-northeast-2"
        credentialsProvider = StaticCredentialsProvider {
            accessKeyId = awsProperties.accessKey
            secretAccessKey = awsProperties.secretKey
        }
    }
}