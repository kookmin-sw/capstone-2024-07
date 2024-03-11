import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. FutureProvider를 사용하여 DepartmentState를 로드하는 함수

final firstDepartmentStateProvider =
    FutureProvider<FirstDepartmentState>((ref) async {
  String jsonString =
      await rootBundle.loadString('asset/jsons/departments.json');
  Map<String, dynamic> divisionAndDepartments = json.decode(jsonString);

  // 초기에 선택되어 있을 계열과 학과를 설정!
  String selectedDivision = divisionAndDepartments.keys.first;
  String selectedDepartment = divisionAndDepartments[selectedDivision][0];

  return FirstDepartmentState(
    divisionAndDepartments: divisionAndDepartments,
    selectedDivision: selectedDivision,
    selectedDepartment: selectedDepartment,
  );
});

class FirstDepartmentState {
  final Map<String, dynamic> divisionAndDepartments;
  String selectedDivision;
  String selectedDepartment;

  FirstDepartmentState({
    required this.divisionAndDepartments,
    required this.selectedDivision,
    required this.selectedDepartment,
  });

  FirstDepartmentState copyWith({
    Map<String, dynamic>? divisionAndDepartments,
    String? selectedDivision,
    String? selectedDepartment,
  }) {
    return FirstDepartmentState(
      divisionAndDepartments:
          divisionAndDepartments ?? this.divisionAndDepartments,
      selectedDivision: selectedDivision ?? this.selectedDivision,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
    );
  }
}

// 2. StateNotifierProvider를 사용하여 DepartmentState를 관리하는 DepartmentListNotifierProvider

final firstDepartmentListNotifierProvider =
    StateNotifierProvider<FirstDepartmentListNotifier, FirstDepartmentState>((ref) {
  // FutureProvider에서 로드된 초기 상태를 사용하여 StateNotifier를 생성
  final initialState = ref.watch(firstDepartmentStateProvider).asData?.value ??
      FirstDepartmentState(
        divisionAndDepartments: {},
        selectedDivision: '',
        selectedDepartment: '',
      );

  return FirstDepartmentListNotifier(initialState);
});

class FirstDepartmentListNotifier extends StateNotifier<FirstDepartmentState> {
  FirstDepartmentListNotifier(FirstDepartmentState state) : super(state);

  // 선택된 계열이나 학과를 변경하는 메서드
  void setSelectedDivision(String division) {
    state = state.copyWith(selectedDivision: division);
  }

  void setSelectedDepartment(String department) {
    state = state.copyWith(selectedDepartment: department);
  }
}
