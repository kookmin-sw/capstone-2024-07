import 'package:json_annotation/json_annotation.dart';

part 'recruitment_comment_response_model.g.dart';

@JsonSerializable()
class RecruitmentCommentResponseModel {
  final int id;
  final int userId;
  final int recruitmentId;
  final String content;
  final String createdDateTime;
  final String modifiedDateTime;

  RecruitmentCommentResponseModel(this.id, this.userId, this.recruitmentId,
      this.content, this.createdDateTime, this.modifiedDateTime);

  factory RecruitmentCommentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RecruitmentCommentResponseModelFromJson(json);
}
