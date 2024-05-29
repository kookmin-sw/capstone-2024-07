package com.dclass.backend.application.mail

interface MailSender {
    suspend fun send(toAddress: String, subjectVal: String, bodyHtml: String)
}
