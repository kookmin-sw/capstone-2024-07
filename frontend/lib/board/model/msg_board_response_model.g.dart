// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_board_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgBoardResponseModel _$MsgBoardResponseModelFromJson(
        Map<String, dynamic> json) =>
    MsgBoardResponseModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      userNickname: json['userNickname'] as String,
      universityName: json['universityName'] as String,
      communityId: (json['communityId'] as num).toInt(),
      communityTitle: json['communityTitle'] as String,
      postTitle: json['postTitle'] as String,
      postContent: json['postContent'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      count: ReactCountModel.fromJson(json['count'] as Map<String, dynamic>),
      isAnonymous: json['isAnonymous'] as bool,
      isBlockedUser: json['isBlockedUser'] as bool,
      imageCount: (json['imageCount'] as num).toInt(),
      createdDateTime: json['createdDateTime'] as String,
    );

Map<String, dynamic> _$MsgBoardResponseModelToJson(
        MsgBoardResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userNickname': instance.userNickname,
      'universityName': instance.universityName,
      'communityId': instance.communityId,
      'communityTitle': instance.communityTitle,
      'postTitle': instance.postTitle,
      'postContent': instance.postContent,
      'images': instance.images,
      'count': instance.count,
      'isAnonymous': instance.isAnonymous,
      'isBlockedUser': instance.isBlockedUser,
      'imageCount': instance.imageCount,
      'createdDateTime': instance.createdDateTime,
    };

ReactCountModel _$ReactCountModelFromJson(Map<String, dynamic> json) =>
    ReactCountModel(
      commentReplyCount: (json['commentReplyCount'] as num).toInt(),
      likeCount: (json['likeCount'] as num).toInt(),
      scrapCount: (json['scrapCount'] as num).toInt(),
    );

Map<String, dynamic> _$ReactCountModelToJson(ReactCountModel instance) =>
    <String, dynamic>{
      'commentReplyCount': instance.commentReplyCount,
      'likeCount': instance.likeCount,
      'scrapCount': instance.scrapCount,
    };
