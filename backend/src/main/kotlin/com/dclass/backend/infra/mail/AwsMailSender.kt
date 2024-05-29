package com.dclass.backend.infra.mail

import aws.sdk.kotlin.services.ses.SesClient
import aws.sdk.kotlin.services.ses.model.*
import com.dclass.backend.application.mail.MailSender
import org.springframework.stereotype.Component

@Component
class AwsMailSender(
    private val client: SesClient,
) : MailSender {

    override suspend fun send(toAddress: String, subjectVal: String, bodyHtml: String) {
        val destinationOb = Destination {
            toAddresses = listOf(toAddress)
        }

        val contentOb = Content {
            data = bodyHtml
        }

        val subOb = Content {
            data = subjectVal
        }

        val bodyOb = Body {
            html = contentOb
        }

        val msgOb = Message {
            subject = subOb
            body = bodyOb
        }

        val emailRequest = SendEmailRequest {
            destination = destinationOb
            message = msgOb
            source = "devbelly@naver.com"
        }

        println("Attempting to send an email through Amazon SES using the AWS SDK for Kotlin...")
        client.sendEmail(emailRequest)
    }
}
