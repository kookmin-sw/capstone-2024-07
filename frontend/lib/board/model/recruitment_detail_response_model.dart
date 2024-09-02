import 'package:frontend/board/model/recruitment_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recruitment_detail_response_model.g.dart';

@JsonSerializable()
class RecruitmentDetailResponseModel extends RecruitmentResponseModel {
  final bool isScrapped;

  RecruitmentDetailResponseModel({
    required super.id,
    required super.departmentId,
    required super.type,
    required super.isOnline,
    required super.isOngoing,
    required super.isAnonymous,
    required super.limit,
    required super.recruitable,
    required super.startDateTime,
    required super.endDateTime,
    required super.title,
    required super.content,
    required super.scrapCount,
    required super.commentReplyCount,
    required super.createdDateTime,
    required super.modifiedDateTime,
    required super.userId,
    required super.userNickname,
    required super.hashTags,
    required this.isScrapped,
  });

  factory RecruitmentDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RecruitmentDetailResponseModelFromJson(json);
}
