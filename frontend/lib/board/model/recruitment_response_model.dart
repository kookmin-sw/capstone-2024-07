import 'package:json_annotation/json_annotation.dart';

part 'recruitment_response_model.g.dart';

@JsonSerializable()
class RecruitmentResponseModel {
  final int id;
  final int departmentId;
  final String type;
  final bool isOnline;
  final bool isOngoing;
  final int limit;
  final bool recruitable;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String title;
  final String content;
  final int scrapCount;
  final int commentReplyCount;
  final DateTime createdDateTime;
  final DateTime modifiedDateTime;
  final int userId;
  final String userNickname;
  final List<HashTagsModel> hashTags;

  RecruitmentResponseModel({
    required this.id,
    required this.departmentId,
    required this.type,
    required this.isOnline,
    required this.isOngoing,
    required this.limit,
    required this.recruitable,
    required this.startDateTime,
    required this.endDateTime,
    required this.title,
    required this.content,
    required this.scrapCount,
    required this.commentReplyCount,
    required this.createdDateTime,
    required this.modifiedDateTime,
    required this.userId,
    required this.userNickname,
    required this.hashTags,
  });

  factory RecruitmentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RecruitmentResponseModelFromJson(json);
}

@JsonSerializable()
class HashTagsModel {
  final String name;
  final String target;
  final int targetId;
  final int id;

  HashTagsModel({
    required this.name,
    required this.target,
    required this.targetId,
    required this.id,
  });

  factory HashTagsModel.fromJson(Map<String, dynamic> json) =>
      _$HashTagsModelFromJson(json);
}
