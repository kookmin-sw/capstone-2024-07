// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      json['id'] as int,
      UserInformation.fromJson(json['userInformation'] as Map<String, dynamic>),
      json['postId'] as int,
      json['content'] as String,
      LikeCount.fromJson(json['likeCount'] as Map<String, dynamic>),
      json['isLiked'] as bool,
      json['createAt'] as String,
      ReplyModel.fromJson(json['replies'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userInformation': instance.userInformation,
      'postId': instance.postId,
      'content': instance.content,
      'likeCount': instance.likeCount,
      'isLiked': instance.isLiked,
      'createAt': instance.createAt,
      'replies': instance.replies,
    };

UserInformation _$UserInformationFromJson(Map<String, dynamic> json) =>
    UserInformation(
      name: json['name'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
    );

Map<String, dynamic> _$UserInformationToJson(UserInformation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'nickname': instance.nickname,
    };

LikeCount _$LikeCountFromJson(Map<String, dynamic> json) => LikeCount(
      likes: (json['likes'] as List<dynamic>).map((e) => e as int).toList(),
      count: json['count'] as int,
    );

Map<String, dynamic> _$LikeCountToJson(LikeCount instance) => <String, dynamic>{
      'likes': instance.likes,
      'count': instance.count,
    };

ReplyModel _$RepliesFromJson(Map<String, dynamic> json) => ReplyModel(
      json['id'] as int,
      json['userId'] as int,
      UserInformation.fromJson(json['userInformation'] as Map<String, dynamic>),
      json['commentId'] as int,
      json['content'] as String,
      LikeCount.fromJson(json['likeCount'] as Map<String, dynamic>),
      json['createdAt'] as String,
    );

Map<String, dynamic> _$RepliesToJson(ReplyModel instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userInformation': instance.userInformation,
      'commentId': instance.commentId,
      'content': instance.content,
      'likeCount': instance.likeCount,
      'createdAt': instance.createdAt,
    };
