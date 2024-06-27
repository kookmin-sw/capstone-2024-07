import 'package:json_annotation/json_annotation.dart';

part 'department.g.dart';

@JsonSerializable()
class Department {
  final int id;
  final String title;

  Department({required this.id, required this.title});

  factory Department.fromJson(Map<String, dynamic> json) => _$DepartmentFromJson(json);
  Map<String, dynamic> toJson() => _$DepartmentToJson(this);
}

@JsonSerializable()
class DepartmentGroup {
  final String groupName;
  final List<Department> departments;

  DepartmentGroup({required this.groupName, required this.departments});

  factory DepartmentGroup.fromJson(Map<String, dynamic> json) => _$DepartmentGroupFromJson(json);
  Map<String, dynamic> toJson() => _$DepartmentGroupToJson(this);
}
