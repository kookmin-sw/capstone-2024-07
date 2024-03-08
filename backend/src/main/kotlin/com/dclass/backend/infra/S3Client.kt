package com.dclass.backend.infra

import aws.sdk.kotlin.runtime.auth.credentials.StaticCredentialsProvider
import aws.sdk.kotlin.services.s3.S3Client
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class S3Configuration(private val awsProperties: AwsProperties) {
    @Bean(destroyMethod = "close")
    fun s3Client() = S3Client {
        region = "ap-northeast-2"
        credentialsProvider = StaticCredentialsProvider {
            accessKeyId = awsProperties.accessKey
            secretAccessKey = awsProperties.secretKey
        }
    }
}
