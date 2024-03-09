package com.dclass.backend.domain.user

import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.support.fixtures.belong
import com.dclass.support.fixtures.university
import com.dclass.support.fixtures.user
import com.dclass.support.test.RepositoryTest
import io.kotest.core.spec.style.BehaviorSpec
import io.kotest.extensions.spring.SpringTestExtension
import io.kotest.extensions.spring.SpringTestLifecycleMode
import io.kotest.matchers.collections.shouldContainExactly
import io.kotest.matchers.collections.shouldHaveSize

@RepositoryTest
class UserRepositoryTest(
    private val userRepository: UserRepository,
    private val belongRepository: BelongRepository,
    private val universityRepository: UniversityRepository,
) : BehaviorSpec({
    extensions(SpringTestExtension(SpringTestLifecycleMode.Root))

    Given("1") {
        val univ = universityRepository.save(university())
        val user = userRepository.save(user(university = univ))
        val belong = belongRepository.save(belong(userId = user.id))

        When("2") {
            val findInfo = userRepository.findUserInfoWithDepartment(user.id)
            val departments = findInfo.departmentIds
            Then("3") {
                println(findInfo.departmentIds)
                for (departmentss1 in departments) {
                    println("departmentss1 = ${departmentss1}")
                }

                findInfo.departmentIds shouldHaveSize 2
                findInfo.departmentIds shouldContainExactly belong.departmentIds
            }
        }

    }
})
