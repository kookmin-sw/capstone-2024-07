package com.dclass.backend.domain.user

import jakarta.persistence.Column
import jakarta.persistence.Embeddable

@Embeddable
data class UserInformation(
    @Column(nullable = false, length = 30)
    val name: String,

    @Column(unique = true, nullable = false)
    val email: String,

    @Column(nullable = false, length = 13)
    var nickname: String,
) {
    fun same(name: String): Boolean {
        return this.name == name
    }

    fun updateAnonymous(index: Int, isAnonymous: Boolean, isOwner: Boolean) {
        if(!isAnonymous){
            return;
        }
        if(index != -1) {
            this.nickname = "익명 ${index+1}"
            if(isOwner) {
                this.nickname = "익명(글쓴이)"
            }
        }
    }
}
