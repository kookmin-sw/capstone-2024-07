// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      (json['id'] as num).toInt(),
      UserInformation.fromJson(json['userInformation'] as Map<String, dynamic>),
      (json['userId'] as num).toInt(),
      (json['postId'] as num).toInt(),
      json['content'] as String,
      json['deleted'] as bool,
      LikeCount.fromJson(json['likeCount'] as Map<String, dynamic>),
      json['isLiked'] as bool,
      json['isBlockedUser'] as bool,
      json['createdAt'] as String,
      (json['replies'] as List<dynamic>)
          .map((e) => ReplyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userInformation': instance.userInformation,
      'userId': instance.userId,
      'postId': instance.postId,
      'content': instance.content,
      'likeCount': instance.likeCount,
      'deleted': instance.deleted,
      'isLiked': instance.isLiked,
      'isBlockedUser': instance.isBlockedUser,
      'createdAt': instance.createdAt,
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
      likes: (json['likes'] as List<dynamic>)
          .map((e) => Likes.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$LikeCountToJson(LikeCount instance) => <String, dynamic>{
      'likes': instance.likes,
      'count': instance.count,
    };

Likes _$LikesFromJson(Map<String, dynamic> json) => Likes(
      (json['usersId'] as num).toInt(),
    );

Map<String, dynamic> _$LikesToJson(Likes instance) => <String, dynamic>{
      'usersId': instance.usersId,
    };

ReplyModel _$ReplyModelFromJson(Map<String, dynamic> json) => ReplyModel(
      (json['id'] as num).toInt(),
      (json['userId'] as num).toInt(),
      UserInformation.fromJson(json['userInformation'] as Map<String, dynamic>),
      (json['commentId'] as num).toInt(),
      json['content'] as String,
      LikeCount.fromJson(json['likeCount'] as Map<String, dynamic>),
      json['isBlockedUser'] as bool,
      json['createdAt'] as String,
    );

Map<String, dynamic> _$ReplyModelToJson(ReplyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userInformation': instance.userInformation,
      'commentId': instance.commentId,
      'content': instance.content,
      'likeCount': instance.likeCount,
      'isBlockedUser': instance.isBlockedUser,
      'createdAt': instance.createdAt,
    };
