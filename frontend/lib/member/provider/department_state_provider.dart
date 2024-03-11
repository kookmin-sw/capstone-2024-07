import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. FutureProvider를 사용하여 DepartmentState를 로드하는 함수

final departmentStateProvider = FutureProvider<DepartmentState>((ref) async {
  String jsonString =
  await rootBundle.loadString('asset/jsons/departments.json');
  Map<String, dynamic> divisionAndDepartments = json.decode(jsonString);

  // 초기에 선택되어 있을 계열과 학과를 설정!
  String selectedDivision = divisionAndDepartments.keys.first;
  String selectedDepartment = divisionAndDepartments[selectedDivision][0];

  return DepartmentState(
    divisionAndDepartments: divisionAndDepartments,
    selectedDivision: selectedDivision,
    selectedDepartment: selectedDepartment,
  );
});

class DepartmentState {
  final Map<String, dynamic> divisionAndDepartments;
  String selectedDivision;
  String selectedDepartment;

  DepartmentState({
    required this.divisionAndDepartments,
    required this.selectedDivision,
    required this.selectedDepartment,
  });

  DepartmentState copyWith({
    Map<String, dynamic>? divisionAndDepartments,
    String? selectedDivision,
    String? selectedDepartment,
  }) {
    return DepartmentState(
      divisionAndDepartments:
      divisionAndDepartments ?? this.divisionAndDepartments,
      selectedDivision: selectedDivision ?? this.selectedDivision,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
    );
  }
}