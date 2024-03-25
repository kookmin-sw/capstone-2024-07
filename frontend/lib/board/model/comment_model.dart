import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final int id;
  final UserInformation userInformation;
  final int postId;
  final String content;
  final LikeCount likeCount;
  final bool isLiked;
  final String createAt;
  final ReplyModel replies;

  CommentModel(this.id, this.userInformation, this.postId, this.content,
      this.likeCount, this.isLiked, this.createAt, this.replies);

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}

@JsonSerializable()
class UserInformation {
  final String name;
  final String email;
  final String nickname;

  UserInformation({
    required this.name,
    required this.email,
    required this.nickname,
  });

  factory UserInformation.fromJson(Map<String, dynamic> json) =>
      _$UserInformationFromJson(json);
}

@JsonSerializable()
class LikeCount {
  final List<int> likes;
  final int count;

  LikeCount({
    required this.likes,
    required this.count,
  });

  factory LikeCount.fromJson(Map<String, dynamic> json) =>
      _$LikeCountFromJson(json);
}

@JsonSerializable()
class ReplyModel {
  final int id;
  final int userId;
  final UserInformation userInformation;
  final int commentId;
  final String content;
  final LikeCount likeCount;
  final String createdAt;

  ReplyModel(
    this.id,
    this.userId,
    this.userInformation,
    this.commentId,
    this.content,
    this.likeCount,
    this.createdAt,
  );
  factory ReplyModel.fromJson(Map<String, dynamic> json) =>
      _$RepliesFromJson(json);
}
