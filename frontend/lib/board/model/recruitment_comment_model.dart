import 'package:frontend/board/model/comment_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recruitment_comment_model.g.dart';

@JsonSerializable()
class RecruitmentCommentModel {
  final int id;
  final UserInformation userInformation;
  final int userId;
  final int recruitmentId;
  final String content;
  final bool deleted;
  final bool isBlockedUser;
  final bool isAnonymous;
  final String createdAt;
  final List<ReplyModel> replies;

  RecruitmentCommentModel(
      this.id,
      this.userInformation,
      this.userId,
      this.recruitmentId,
      this.content,
      this.deleted,
      this.isBlockedUser,
      this.isAnonymous,
      this.createdAt,
      this.replies);

  factory RecruitmentCommentModel.fromJson(Map<String, dynamic> json) =>
      _$RecruitmentCommentModelFromJson(json);
}
