// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_board_detail_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgBoardDetailResponseModel _$MsgBoardDetailResponseModelFromJson(
        Map<String, dynamic> json) =>
    MsgBoardDetailResponseModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      userNickname: json['userNickname'] as String,
      universityName: json['universityName'] as String,
      communityId: json['communityId'] as int,
      communityTitle: json['communityTitle'] as String,
      postTitle: json['postTitle'] as String,
      postContent: json['postContent'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      count: ReactCountModel.fromJson(json['count'] as Map<String, dynamic>),
      isQuestion: json['isQuestion'] as bool,
      isScrapped: json['isScrapped'] as bool,
      likedBy: json['likedBy'] as bool,
      createdDateTime: json['createdDateTime'] as String,
    );

Map<String, dynamic> _$MsgBoardDetailResponseModelToJson(
        MsgBoardDetailResponseModel instance) =>
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
      'isQuestion': instance.isQuestion,
      'isScrapped': instance.isScrapped,
      'likedBy': instance.likedBy,
      'createdDateTime': instance.createdDateTime,
    };

ReactCountModel _$ReactCountModelFromJson(Map<String, dynamic> json) =>
    ReactCountModel(
      commentReplyCount: json['commentReplyCount'] as int,
      likeCount: json['likeCount'] as int,
      scrapCount: json['scrapCount'] as int,
    );

Map<String, dynamic> _$ReactCountModelToJson(ReactCountModel instance) =>
    <String, dynamic>{
      'commentReplyCount': instance.commentReplyCount,
      'likeCount': instance.likeCount,
      'scrapCount': instance.scrapCount,
    };
