package com.dclass.backend.application

import com.dclass.backend.application.dto.UpdateDepartmentRequest
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.belong.getOrThrow
import com.dclass.backend.domain.department.DepartmentRepository
import com.dclass.backend.domain.department.getByIdOrThrow
import com.dclass.backend.domain.department.getByTitleOrThrow
import com.dclass.backend.exception.department.DepartmentException
import com.dclass.backend.exception.department.DepartmentExceptionType.*
import com.dclass.support.fixtures.belong
import com.dclass.support.fixtures.department
import io.kotest.assertions.throwables.shouldThrow
import io.kotest.core.spec.style.BehaviorSpec
import io.kotest.matchers.shouldBe
import io.mockk.every
import io.mockk.mockk
import java.time.LocalDateTime
import java.util.*

val UPDATEABLE = LocalDateTime.now().minusDays(100)

class BelongServiceTest : BehaviorSpec({

    val departmentRepository = mockk<DepartmentRepository>()
    val belongRepository = mockk<BelongRepository>()

    val belongService = BelongService(departmentRepository, belongRepository)

    Given("두 개의 학과가 존재하는 경우") {
        val userId = 1L
        val request = UpdateDepartmentRequest(major = "조선공학과", minor = "산업공학과")

        every { departmentRepository.getByTitleOrThrow(request.major) } returns department(id = 3L, title = request.major)
        every { departmentRepository.getByTitleOrThrow(request.minor) } returns department(id = 4L, title = request.minor)

        val belong = belong(userId = userId, modifiedDateTime = UPDATEABLE)
        every { belongRepository.getOrThrow(userId) } returns belong

        When("특정 회원이 학과를 변경하면") {
            val actual = belongService.editDepartments(userId, request)

            Then("회원의 학과가 변경된다") {
                belong.major shouldBe 3L
                belong.minor shouldBe 4L
            }
        }
    }

    Given("학과가 존재하지 않는 경우"){
        val userId = 1L
        val request = UpdateDepartmentRequest(major = "존재하지않는 학과", minor = "산업공학과")

        every { departmentRepository.getByTitleOrThrow(request.major) } throws DepartmentException(
            NOT_FOUND_DEPARTMENT
        )
        every { departmentRepository.getByTitleOrThrow(request.minor) } returns department(id = 4L, title = request.minor)

        val belong = belong(userId = userId, modifiedDateTime = UPDATEABLE)
        every { belongRepository.getOrThrow(userId) } returns belong

        When("특정 회원이 학과를 변경하면") {
            Then("예외가 발생한다") {
                shouldThrow<DepartmentException> {
                    belongService.editDepartments(userId, request)
                }.exceptionType() shouldBe NOT_FOUND_DEPARTMENT

            }
        }
    }
})