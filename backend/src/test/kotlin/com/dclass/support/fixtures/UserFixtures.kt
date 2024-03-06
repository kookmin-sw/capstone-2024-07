package com.dclass.support.fixtures

import com.dclass.backend.domain.user.University
import com.dclass.backend.domain.user.User
import java.util.*

val usernames = listOf("devbelly", "zkxmdkdltm", "hongbuly", "jia5232")

fun user(
    id: Long = 0L,
    name: String = "username",
    email: String = UUID.randomUUID().toString().take(6) + "@kookmin.ac.kr",
    nickname: String = usernames.random(),
    password: String = "password",
    university: University = university()
): User {
    return User(
        id = id,
        name = name,
        email = email,
        password = password,
        nickname = nickname,
        university = university
    )
}