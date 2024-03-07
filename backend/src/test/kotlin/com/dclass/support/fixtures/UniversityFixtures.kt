package com.dclass.support.fixtures

import com.dclass.backend.domain.user.University

fun university(
    id: Long = 1L,
    name: String = "국민대학교",
    emailSuffix: String = "kookmin.ac.kr",
    logo: String = "logo"
): University {
    return University(
        id = id,
        name = name,
        emailSuffix = emailSuffix,
        logo = logo
    )
}