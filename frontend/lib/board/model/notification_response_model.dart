import 'package:json_annotation/json_annotation.dart';

part 'notification_response_model.g.dart';

@JsonSerializable()
class NotificationResponseModel {
  final int id;
  final int userId;
  final int postId;
  final int commentId;
  final String content;
  final String type;
  final String createdAt;
  final bool isRead;
  final String communityTitle;

  NotificationResponseModel(
      this.id,
      this.userId,
      this.postId,
      this.commentId,
      this.content,
      this.type,
      this.createdAt,
      this.isRead,
      this.communityTitle);

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseModelFromJson(json);
}
