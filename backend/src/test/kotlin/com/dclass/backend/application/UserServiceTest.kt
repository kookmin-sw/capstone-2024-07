package com.dclass.backend.application

import com.dclass.backend.application.dto.EditPasswordRequest
import com.dclass.backend.application.dto.ResetPasswordRequest
import com.dclass.backend.application.dto.UserResponse
import com.dclass.backend.domain.user.*
import com.dclass.support.fixtures.*
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

    Given("특정 회원이 있고 변경할 비밀번호가 있는 경우") {
        val user = user(id = 1L, password = PASSWORD.value)
        val password = NEW_PASSWORD

        every { userRepository.getOrThrow(any()) } returns user

        When("기존 비밀번호와 함께 새 비밀번호를 변경하면") {
            userService.editPassword(user.id, EditPasswordRequest(user.password, password, password))

            Then("새 비밀번호로 변경된다") {
                user.password shouldBe password
            }
        }

        When("일치하지 않는 기존 비밀번호와 함께 새 비밀번호를 변경하면") {
            Then("예외가 발생한다") {
                shouldThrow<UnidentifiedUserException> {
                    userService.editPassword(user.id, EditPasswordRequest(WRONG_PASSWORD, password, password))
                }
            }
        }

        When("이전 비밀번호는 일치하지만 새 비밀번호와 확인 비밀번호가 일치하지 않으면") {
            Then("예외가 발생한다") {
                shouldThrow<IllegalArgumentException> {
                    userService.editPassword(user.id, EditPasswordRequest(user.password, password, WRONG_PASSWORD))
                }
            }
        }
    }

    Given("특정 회원이 있는 경우") {
        val user = user(id = 1L)

        every { userRepository.getOrThrow(any()) } returns user

        When("해당 회원의 정보를 조회하면") {
            val actual = userService.getInformation(user.id)

            Then("회원 정보를 확인할 수 있다") {
                actual shouldBe UserResponse(user)
            }
        }
    }
})