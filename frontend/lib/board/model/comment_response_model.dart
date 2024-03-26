import 'package:json_annotation/json_annotation.dart';

part 'comment_response_model.g.dart';

@JsonSerializable()
class CommentResponseModel {
  final int id;
  final int userId;
  final int postId;
  final String content;
  final String createdDateTime;
  final String modifiedDateTime;

  CommentResponseModel(this.id, this.userId, this.postId, this.content,
      this.createdDateTime, this.modifiedDateTime);

  factory CommentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CommentResponseModelFromJson(json);
}
