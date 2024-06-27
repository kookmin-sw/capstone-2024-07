// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Department _$DepartmentFromJson(Map<String, dynamic> json) => Department(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
    );

Map<String, dynamic> _$DepartmentToJson(Department instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };

DepartmentGroup _$DepartmentGroupFromJson(Map<String, dynamic> json) =>
    DepartmentGroup(
      groupName: json['groupName'] as String,
      departments: (json['departments'] as List<dynamic>)
          .map((e) => Department.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DepartmentGroupToJson(DepartmentGroup instance) =>
    <String, dynamic>{
      'groupName': instance.groupName,
      'departments': instance.departments,
    };
