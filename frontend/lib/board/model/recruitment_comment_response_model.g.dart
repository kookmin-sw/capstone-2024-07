// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruitment_comment_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruitmentCommentResponseModel _$RecruitmentCommentResponseModelFromJson(
        Map<String, dynamic> json) =>
    RecruitmentCommentResponseModel(
      (json['id'] as num).toInt(),
      (json['userId'] as num).toInt(),
      (json['recruitmentId'] as num).toInt(),
      json['content'] as String,
      json['createdDateTime'] as String,
      json['modifiedDateTime'] as String,
    );

Map<String, dynamic> _$RecruitmentCommentResponseModelToJson(
        RecruitmentCommentResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'recruitmentId': instance.recruitmentId,
      'content': instance.content,
      'createdDateTime': instance.createdDateTime,
      'modifiedDateTime': instance.modifiedDateTime,
    };
