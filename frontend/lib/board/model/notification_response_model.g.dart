// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationResponseModel _$NotificationResponseModelFromJson(
        Map<String, dynamic> json) =>
    NotificationResponseModel(
      json['id'] as int,
      json['userId'] as int,
      json['postId'] as int,
      json['commentId'] as int,
      json['content'] as String,
      json['type'] as String,
      json['createdAt'] as String,
      json['isRead'] as bool,
      json['communityTitle'] as String,
    );

Map<String, dynamic> _$NotificationResponseModelToJson(
        NotificationResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'postId': instance.postId,
      'commentId': instance.commentId,
      'content': instance.content,
      'type': instance.type,
      'createdAt': instance.createdAt,
      'isRead': instance.isRead,
      'communityTitle': instance.communityTitle,
    };
