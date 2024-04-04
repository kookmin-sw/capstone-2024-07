package com.dclass.backend.application

import com.dclass.backend.domain.blacklist.Blacklist
import com.dclass.backend.domain.blacklist.BlacklistRepository
import com.dclass.backend.exception.blacklist.BlacklistException
import com.dclass.backend.exception.blacklist.BlacklistExceptionType.ALREADY_LOGOUT
import com.dclass.backend.security.JwtTokenProvider
import com.dclass.support.fixtures.blacklist
import io.kotest.assertions.throwables.shouldThrow
import io.kotest.core.spec.style.BehaviorSpec
import io.kotest.matchers.shouldBe
import io.mockk.every
import io.mockk.justRun
import io.mockk.mockk
import io.mockk.verify

class BlacklistServiceTest : BehaviorSpec({

    val blacklistRepository = mockk<BlacklistRepository>()
    val jwtTokenProvider = mockk<JwtTokenProvider>()

    val blacklistService = BlacklistService(blacklistRepository, jwtTokenProvider)

    Given("이미 사용자가 로그아웃한 경우") {
        val token = "alreadyBlacklistedToken"
        val alreadyBlacklistedToken: Blacklist = blacklist(invalidRefreshToken = token)

        justRun { jwtTokenProvider.validateToken(any()) }
        every { blacklistRepository.findByInvalidRefreshToken(any()) } returns alreadyBlacklistedToken

        When("해당 토큰으로 재발급하면") {
            Then("예외가 발생한다") {
                shouldThrow<BlacklistException> {
                    blacklistService.reissueToken(token)
                }.exceptionType() shouldBe ALREADY_LOGOUT
            }
        }
    }

    Given("토큰이 유효하고 사용자가 로그아웃하지 않은 경우") {
        val token = "valid"

        justRun { jwtTokenProvider.validateToken(any()) }
        every { blacklistRepository.findByInvalidRefreshToken(any()) } returns null
        every { blacklistRepository.save(any()) } returns blacklist()
        every { jwtTokenProvider.getSubject(any()) } returns "email@naver.com"
        every { jwtTokenProvider.createAccessToken(any()) } returns "accessToken"
        every { jwtTokenProvider.createRefreshToken(any()) } returns "refreshToken"

        When("해당 토큰으로 재발급 하면") {
            val response = blacklistService.reissueToken(token)

            Then("새로운 토큰을 발급한다") {
                verify { blacklistRepository.save(any()) }

                response.accessToken shouldBe "accessToken"
                response.refreshToken shouldBe "refreshToken"
            }
        }
    }
})
