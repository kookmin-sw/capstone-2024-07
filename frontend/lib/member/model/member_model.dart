import 'package:json_annotation/json_annotation.dart';

part 'member_model.g.dart';

abstract class MemberModelBase {}

@JsonSerializable()
class MemberModel extends MemberModelBase {
  final int id;
  final String email;
  final String nickname;
  final String univName;

  MemberModel({
    required this.id,
    required this.email,
    required this.nickname,
    required this.univName,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);
}

class MemberModelLoading extends MemberModelBase {}

class MemberModelError extends MemberModelBase {
  final String message;

  MemberModelError({
    required this.message,
  });
}
