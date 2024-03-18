package com.dclass.backend.domain.user

import com.dclass.support.domain.BaseRootEntity
import jakarta.persistence.*

@Entity
@Table(name = "users")
class User(

    @Embedded
    private var information: UserInformation,

    @AttributeOverride(name = "value", column = Column(name = "password", nullable = false))
    @Embedded
    var password: Password,

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "university_id", nullable = false)
    val university: University,

    id: Long = 0L
) : BaseRootEntity<User>(id) {

    val name: String
        get() = information.name

    val email: String
        get() = information.email

    val nickname: String
        get() = information.nickname

    val universityName: String
        get() = university.name

    constructor(
        name: String,
        email: String,
        nickname: String,
        password: String,
        university: University,
        id: Long = 0L
    ) : this(
        UserInformation(name, email, nickname), Password(password), university, id,
    )

    fun authenticate(password: Password) {
        require(password == this.password) { "사용자 정보가 일치하지 않습니다." }
    }

    fun resetPassword(name: String, password: String) {
        identify(information.same(name)) { "사용자 정보가 일치하지 않습니다." }
        this.password = Password(password)
        registerEvent(PasswordResetEvent(id, name, email, password))
    }

    fun changePassword(oldPassword: Password, newPassword: Password) {
        identify(this.password == oldPassword) { "기존 비밀번호가 일치하지 않습니다." }
        this.password = newPassword
    }

    fun changeNickname(nickname: String) {
        this.information = information.copy(nickname = nickname)
    }

    private fun identify(value: Boolean, lazyMessage: () -> Any = {}) {
        if (!value) {
            val message = lazyMessage()
            throw UnidentifiedUserException(message.toString())
        }
    }
}