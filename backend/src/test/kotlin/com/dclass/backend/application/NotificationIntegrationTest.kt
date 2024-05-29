package com.dclass.backend.application

import com.dclass.backend.application.dto.NotificationCommentRequest
import com.dclass.backend.domain.emitter.EmitterRepository
import com.dclass.backend.domain.notification.Notification
import com.dclass.backend.domain.notification.NotificationRepository
import com.dclass.backend.domain.notification.NotificationType
import com.dclass.backend.domain.notification.getOrThrow
import com.dclass.backend.domain.user.UniversityRepository
import com.dclass.backend.domain.user.UserRepository
import com.dclass.support.fixtures.university
import com.dclass.support.fixtures.user
import com.dclass.support.test.IntegrationTest
import io.kotest.core.spec.style.BehaviorSpec
import io.kotest.extensions.spring.SpringTestExtension
import io.kotest.extensions.spring.SpringTestLifecycleMode
import io.kotest.matchers.shouldBe

private val DEFAULT_TIMEOUT = 60L * 1000L * 60L

private fun makeTimeIncludeId(id: Long): String {
    return "${id}_${System.currentTimeMillis()}"
}

@IntegrationTest
class NotificationIntegrationTest(
    private val notificationService: NotificationService,
    private val notificationRepository: NotificationRepository,
    private val emitterRepository: EmitterRepository,
    private val userRepository: UserRepository,
    private val universityRepository: UniversityRepository,
) : BehaviorSpec({

    extensions(SpringTestExtension(SpringTestLifecycleMode.Root))

    Given("특정 사용자가 알림을 구독하고 있는 경우") {
        val univ = universityRepository.save(university())

        val user = userRepository.save(user(university = univ))
        val emitter = notificationService.subscribe(user.id, "")

        val emitterId = makeTimeIncludeId(user.id)
        emitterRepository.save(emitterId, emitter)

        When("해당 사용자의 이미터를 조회하면") {
            val actual = emitterRepository.get(emitterId)

            Then("이미터가 조회된다") {
                actual shouldBe emitter
            }
        }

        When("해당 사용자에게 알림을 전송하면") {
            notificationService.send(
                NotificationCommentRequest(user.id, 1, 1, "알림내용", "FREE", NotificationType.COMMENT),
            )

            Then("알림이 전송된다") {
                val notification = notificationRepository.findAll().first()
                val event = emitterRepository.findAllEventCacheStartWithByUserId(user.id.toString()).values.first()
                event shouldBe notification
            }
        }

        When("해당 사용자가 알림을 읽으면") {
            val notification = notificationRepository.save(
                Notification(user.id, 1, "알림내용", type = NotificationType.COMMENT),
            )
            notificationService.readNotification(notification.id)

            Then("알림이 읽힌다") {
                notificationRepository.getOrThrow(notification.id).isRead shouldBe true
            }
        }
    }
})
