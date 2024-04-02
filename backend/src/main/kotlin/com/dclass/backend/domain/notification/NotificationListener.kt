package com.dclass.backend.domain.notification

import com.dclass.backend.application.NotificationService
import com.dclass.backend.application.dto.NotificationCommentRequest
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.springframework.stereotype.Component
import org.springframework.transaction.event.TransactionalEventListener

@Component
class NotificationListener(
    private val notificationService: NotificationService
) {

    @TransactionalEventListener
    fun sendNotificationForComment(event: NotificationCommentEvent) =
        CoroutineScope(Dispatchers.IO).launch {
            notificationService.send(
                NotificationCommentRequest(
                    userId = event.userId,
                    postId = event.postId,
                    commentId = event.commentId,
                    content = event.content,
                    communityTitle = event.community,
                    type = event.type
                )
            )
        }


}