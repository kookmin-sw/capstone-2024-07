import 'package:json_annotation/json_annotation.dart';

part 'msg_board_response_model.g.dart';

@JsonSerializable()
class MsgBoardResponseModel {
  final int id;
  final int userId;
  final String userNickname;
  final String universityName;
  final int communityId;
  final String communityTitle;
  final String postTitle;
  final String postContent;
  final List<String> images;
  final ReactCountModel count;
  final bool isQuestion;
  final String createdDateTime;

  MsgBoardResponseModel({
    required this.id,
    required this.userId,
    required this.userNickname,
    required this.universityName,
    required this.communityId,
    required this.communityTitle,
    required this.postTitle,
    required this.postContent,
    required this.images,
    required this.count,
    required this.isQuestion,
    required this.createdDateTime,
  });

  factory MsgBoardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MsgBoardResponseModelFromJson(json);
}

@JsonSerializable()
class ReactCountModel {
  final int commentReplyCount;
  final int likeCount;

  ReactCountModel({
    required this.commentReplyCount,
    required this.likeCount,
  });

  factory ReactCountModel.fromJson(Map<String, dynamic> json) =>
      _$ReactCountModelFromJson(json);
}
