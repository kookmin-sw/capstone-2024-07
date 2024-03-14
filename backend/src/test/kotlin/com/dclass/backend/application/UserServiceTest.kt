package com.dclass.backend.application

import com.dclass.backend.application.dto.*
import com.dclass.backend.domain.belong.Belong
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.department.DepartmentRepository
import com.dclass.backend.domain.user.*
import com.dclass.support.fixtures.*
import io.kotest.assertions.throwables.shouldThrow
import io.kotest.core.spec.style.BehaviorSpec
import io.kotest.matchers.shouldBe
import io.mockk.every
import io.mockk.mockk
import org.springframework.data.repository.findByIdOrNull

class UserServiceTest : BehaviorSpec({
    val userRepository = mockk<UserRepository>()
    val passwordGenerator = mockk<PasswordGenerator>()
    val departmentRepository = mockk<DepartmentRepository>()
    val belongRepository = mockk<BelongRepository>()

    val userService =
        UserService(userRepository, passwordGenerator, departmentRepository, belongRepository)

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
            userService.editPassword(
                user.id,
                EditPasswordRequest(user.password, password, password)
            )

            Then("새 비밀번호로 변경된다") {
                user.password shouldBe password
            }
        }

        When("일치하지 않는 기존 비밀번호와 함께 새 비밀번호를 변경하면") {
            Then("예외가 발생한다") {
                shouldThrow<UnidentifiedUserException> {
                    userService.editPassword(
                        user.id,
                        EditPasswordRequest(WRONG_PASSWORD, password, password)
                    )
                }
            }
        }

        When("이전 비밀번호는 일치하지만 새 비밀번호와 확인 비밀번호가 일치하지 않으면") {
            Then("예외가 발생한다") {
                shouldThrow<IllegalArgumentException> {
                    userService.editPassword(
                        user.id,
                        EditPasswordRequest(user.password, password, WRONG_PASSWORD)
                    )
                }
            }
        }
    }

    Given("특정 회원이 학과에 속한 경우") {
        val user = user(id = 1L)
        val department = department()
        val department2 = department(2L, "경영학과")

        every { userRepository.findUserInfoWithDepartment(any()) } returns UserResponseWithDepartment(
            UserResponse(user),
            listOf(department.id, department2.id),
        )
        every { belongRepository.getOrThrow(any()) } returns Belong(
            user.id,
            listOf(department.id, department2.id),
        )
        every { departmentRepository.findAllById(any()) } returns listOf(department, department2)

        When("해당 회원의 정보를 조회하면") {
            val actual = userService.getInformation(user.id)
            val belong = belongRepository.getOrThrow(user.id)

            Then("회원 정보를 확인할 수 있다") {
                actual shouldBe UserResponseWithDepartmentNames(
                    userRepository.findByIdOrNull(user.id)!!,
                    department.title,
                    department2.title,
                )
                belong.activated shouldBe department.id
                actual.major shouldBe department.title
                actual.minor shouldBe department2.title
            }
        }

        When("해당 회원의 활성화된 전공이 바뀐 경우에도") {
            userService.switchDepartment(user.id)
            val actual = userService.getInformation(user.id)

            Then("기존 전공/부전공은 바뀌지 않는다") {
                actual.major shouldBe department.title
                actual.minor shouldBe department2.title
            }
        }
    }

    Given("해당 회원이 선택한 전공이 하나인 경우엔") {
        val user = user(id = 1L)
        val department = department()
        val department2 = department(id = 999, title = "")

        every { belongRepository.getOrThrow(any()) } returns Belong(
            user.id,
            listOf(department.id, department2.id),
        )
        every { departmentRepository.findAllById(any()) } returns listOf(department, department2)

        When("해당 회원의 정보를 조회하면") {
            val belong = belongRepository.getOrThrow(user.id)

            val actual = userService.getInformation(user.id)

            Then("부전공은 존재하지 않는다") {
                actual.major shouldBe department.title
                actual.minor shouldBe ""
            }
        }
    }
})