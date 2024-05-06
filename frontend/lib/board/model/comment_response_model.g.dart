// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentResponseModel _$CommentResponseModelFromJson(
        Map<String, dynamic> json) =>
    CommentResponseModel(
      (json['id'] as num).toInt(),
      (json['userId'] as num).toInt(),
      (json['postId'] as num).toInt(),
      json['content'] as String,
      json['createdDateTime'] as String,
      json['modifiedDateTime'] as String,
    );

Map<String, dynamic> _$CommentResponseModelToJson(
        CommentResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'postId': instance.postId,
      'content': instance.content,
      'createdDateTime': instance.createdDateTime,
      'modifiedDateTime': instance.modifiedDateTime,
    };
