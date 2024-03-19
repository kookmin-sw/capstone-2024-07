package com.dclass.backend.domain.user

import com.dclass.backend.exception.user.UserException
import com.dclass.backend.exception.user.UserExceptionType.INVALID_PASSWORD_ACCESS_DENIED
import com.dclass.backend.exception.user.UserExceptionType.INVALID_USER_INFORMATION
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
        if (password != this.password) throw UserException(INVALID_PASSWORD_ACCESS_DENIED)
    }

    fun resetPassword(name: String, password: String) {
        if (!information.same(name)) throw UserException(INVALID_USER_INFORMATION)
        this.password = Password(password)
        registerEvent(PasswordResetEvent(id, name, email, password))
    }

    fun changePassword(oldPassword: Password, newPassword: Password) {
        if (oldPassword != password) throw UserException(INVALID_PASSWORD_ACCESS_DENIED)
        this.password = newPassword
    }

    fun changeNickname(nickname: String) {
        this.information = information.copy(nickname = nickname)
    }
}