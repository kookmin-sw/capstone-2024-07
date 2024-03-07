package com.dclass.support.fixtures

import com.dclass.support.domain.Image

fun createImage(
    key: String
): Image {
    return Image(
        imageKey = key
    )
}