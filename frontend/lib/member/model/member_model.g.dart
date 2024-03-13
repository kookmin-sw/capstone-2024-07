// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => MemberModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      universityName: json['universityName'] as String,
      major: json['major'] as String,
      minor: json['minor'] as String,
    );

Map<String, dynamic> _$MemberModelToJson(MemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'nickname': instance.nickname,
      'universityName': instance.universityName,
      'major': instance.major,
      'minor': instance.minor,
    };
