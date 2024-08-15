// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruitment_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruitmentCommentModel _$RecruitmentCommentModelFromJson(
        Map<String, dynamic> json) =>
    RecruitmentCommentModel(
      (json['id'] as num).toInt(),
      UserInformation.fromJson(json['userInformation'] as Map<String, dynamic>),
      (json['userId'] as num).toInt(),
      (json['recruitmentId'] as num).toInt(),
      json['content'] as String,
      json['deleted'] as bool,
      json['isBlockedUser'] as bool,
      json['isAnonymous'] as bool,
      json['createdAt'] as String,
      (json['replies'] as List<dynamic>)
          .map((e) => RecruitmentReplyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecruitmentCommentModelToJson(
        RecruitmentCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userInformation': instance.userInformation,
      'userId': instance.userId,
      'recruitmentId': instance.recruitmentId,
      'content': instance.content,
      'deleted': instance.deleted,
      'isBlockedUser': instance.isBlockedUser,
      'isAnonymous': instance.isAnonymous,
      'createdAt': instance.createdAt,
      'replies': instance.replies,
    };

RecruitmentReplyModel _$RecruitmentReplyModelFromJson(
        Map<String, dynamic> json) =>
    RecruitmentReplyModel(
      (json['id'] as num).toInt(),
      (json['userId'] as num).toInt(),
      UserInformation.fromJson(json['userInformation'] as Map<String, dynamic>),
      (json['commentId'] as num).toInt(),
      json['content'] as String,
      json['isBlockedUser'] as bool,
      json['createdAt'] as String,
    );

Map<String, dynamic> _$RecruitmentReplyModelToJson(
        RecruitmentReplyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'commentId': instance.commentId,
      'content': instance.content,
      'isBlockedUser': instance.isBlockedUser,
      'userInformation': instance.userInformation,
      'createdAt': instance.createdAt,
    };
