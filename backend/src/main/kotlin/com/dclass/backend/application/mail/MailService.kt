package com.dclass.backend.application.mail

import com.dclass.backend.domain.user.PasswordResetEvent
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.springframework.stereotype.Service
import org.springframework.transaction.event.TransactionalEventListener
import org.thymeleaf.context.Context
import org.thymeleaf.spring6.ISpringTemplateEngine

@Service
class MailService(
    private val mailSender: MailSender,
    private val templateEngine: ISpringTemplateEngine,
) {
    fun sendAuthenticationCodeMail(email: String, authenticationCode: String) =
        CoroutineScope(Dispatchers.IO).launch {
            val context = Context().apply {
                setVariables(mapOf("authenticationCode" to authenticationCode))
            }

            mailSender.send(
                email,
                "메일 인증 코드를 발송해 드립니다. ",
                templateEngine.process("mail/email-authentication.html", context),
            )
        }

    @TransactionalEventListener
    fun sendPasswordResetMail(event: PasswordResetEvent) =
        CoroutineScope(Dispatchers.IO).launch {
            val context = Context().apply {
                setVariables(
                    mapOf(
                        "name" to event.name,
                        "password" to event.password,
                    ),
                )
            }

            mailSender.send(
                event.email,
                "${event.name}님, 임시 비밀번호를 발송해 드립니다.",
                templateEngine.process("mail/password-reset.html", context),
            )
        }
}
