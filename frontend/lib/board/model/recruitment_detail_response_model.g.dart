// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruitment_detail_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruitmentDetailResponseModel _$RecruitmentDetailResponseModelFromJson(
        Map<String, dynamic> json) =>
    RecruitmentDetailResponseModel(
      id: (json['id'] as num).toInt(),
      departmentId: (json['departmentId'] as num).toInt(),
      type: json['type'] as String,
      isOnline: json['isOnline'] as bool,
      isOngoing: json['isOngoing'] as bool,
      isAnonymous: json['isAnonymous'] as bool,
      limit: (json['limit'] as num).toInt(),
      recruitable: json['recruitable'] as bool,
      startDateTime: DateTime.parse(json['startDateTime'] as String),
      endDateTime: DateTime.parse(json['endDateTime'] as String),
      title: json['title'] as String,
      content: json['content'] as String,
      scrapCount: (json['scrapCount'] as num).toInt(),
      commentReplyCount: (json['commentReplyCount'] as num).toInt(),
      createdDateTime: DateTime.parse(json['createdDateTime'] as String),
      modifiedDateTime: DateTime.parse(json['modifiedDateTime'] as String),
      userId: (json['userId'] as num).toInt(),
      userNickname: json['userNickname'] as String,
      hashTags: (json['hashTags'] as List<dynamic>)
          .map((e) => HashTagsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isScrapped: json['isScrapped'] as bool,
    );

Map<String, dynamic> _$RecruitmentDetailResponseModelToJson(
        RecruitmentDetailResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'departmentId': instance.departmentId,
      'type': instance.type,
      'isOnline': instance.isOnline,
      'isOngoing': instance.isOngoing,
      'isAnonymous': instance.isAnonymous,
      'limit': instance.limit,
      'recruitable': instance.recruitable,
      'startDateTime': instance.startDateTime.toIso8601String(),
      'endDateTime': instance.endDateTime.toIso8601String(),
      'title': instance.title,
      'content': instance.content,
      'scrapCount': instance.scrapCount,
      'commentReplyCount': instance.commentReplyCount,
      'createdDateTime': instance.createdDateTime.toIso8601String(),
      'modifiedDateTime': instance.modifiedDateTime.toIso8601String(),
      'userId': instance.userId,
      'userNickname': instance.userNickname,
      'hashTags': instance.hashTags,
      'isScrapped': instance.isScrapped,
    };
