package com.dclass.backend.application

import com.dclass.backend.application.dto.ResetPasswordRequest
import com.dclass.backend.domain.user.Password
import com.dclass.backend.domain.user.UnidentifiedUserException
import com.dclass.backend.domain.user.UserRepository
import com.dclass.backend.domain.user.findByEmail
import com.dclass.support.fixtures.RANDOM_PASSWORD_TEXT
import com.dclass.support.fixtures.user
import io.kotest.assertions.throwables.shouldThrow
import io.kotest.core.spec.style.BehaviorSpec
import io.kotest.matchers.shouldBe
import io.mockk.every
import io.mockk.mockk

class UserServiceTest : BehaviorSpec({
    val userRepository = mockk<UserRepository>()
    val passwordGenerator = mockk<PasswordGenerator>()

    val userService = UserService(userRepository, passwordGenerator)

    Given("특정 회원의 개인정보가 있는 경우") {
        val user = user()

        every { userRepository.findByEmail(any()) } returns user
        every { passwordGenerator.generate() } returns RANDOM_PASSWORD_TEXT
        every { userRepository.save(any()) } returns user

        When("동일한 개인정보로 비밀번호를 초기화하면") {
            userService.resetPassword(ResetPasswordRequest(user.name, user.email))

            Then("비밀번호가 초기화된다") {
                user.password shouldBe Password(RANDOM_PASSWORD_TEXT)
            }
        }

        When("일치하지 않는 개인정보로 비밀번호를 초기화하면") {
            Then("예외가 발생한다") {
                shouldThrow<UnidentifiedUserException> {
                    userService.resetPassword(ResetPasswordRequest("가짜 이름", user.email))
                }
            }
        }
    }
})