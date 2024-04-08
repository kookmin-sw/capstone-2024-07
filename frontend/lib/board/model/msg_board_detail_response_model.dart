import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'msg_board_detail_response_model.g.dart';

@JsonSerializable()
class MsgBoardDetailResponseModel extends MsgBoardResponseModel {
  final bool isScrapped;
  final bool likedBy;

  MsgBoardDetailResponseModel({
    required super.id,
    required super.userId,
    required super.userNickname,
    required super.universityName,
    required super.communityId,
    required super.communityTitle,
    required super.postTitle,
    required super.postContent,
    required super.images,
    required super.count,
    required super.isQuestion,
    required this.isScrapped,
    required this.likedBy,
    required super.createdDateTime,
  });

  factory MsgBoardDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MsgBoardDetailResponseModelFromJson(json);
}
