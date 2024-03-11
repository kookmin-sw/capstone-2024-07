import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'department_state_provider.dart';

// 2. StateNotifierProvider를 사용하여 DepartmentState를 관리하는 DepartmentListNotifierProvider

final departmentListNotifierProvider = StateNotifierProvider<DepartmentListNotifier, DepartmentState>((ref) {

  // FutureProvider에서 로드된 초기 상태를 사용하여 StateNotifier를 생성
  final initialState = ref.watch(departmentStateProvider).asData?.value ?? DepartmentState(divisionAndDepartments: {}, selectedDivision: '', selectedDepartment: '');

  return DepartmentListNotifier(initialState);
});

class DepartmentListNotifier extends StateNotifier<DepartmentState>{
  DepartmentListNotifier(DepartmentState state) : super(state);

  // 선택된 계열이나 학과를 변경하는 메서드
  void setSelectedDivision(String division){
    state = state.copyWith(selectedDivision: division);
  }

  void setSelectedDepartment(String department){
    state = state.copyWith(selectedDepartment: department);
  }
}