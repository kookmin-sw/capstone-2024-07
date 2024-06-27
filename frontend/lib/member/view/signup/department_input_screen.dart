import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/member/model/department.dart';
import 'package:frontend/member/view/signup/signup_complete_screen.dart';

import '../../provider/department_provider.dart';
import '../../provider/signup_provider.dart';

class DepartmentInputScreen extends ConsumerStatefulWidget {
  @override
  _DepartmentInputScreenState createState() => _DepartmentInputScreenState();
}

class _DepartmentInputScreenState extends ConsumerState<DepartmentInputScreen> {
  String? selectedGroup1;
  Department? selectedDepartment1;
  String? selectedGroup2;
  Department? selectedDepartment2;

  @override
  void initState() {
    super.initState();
    ref.read(departmentProvider);
  }

  @override
  Widget build(BuildContext context) {
    final departmentGroups = ref.watch(departmentProvider).asData?.value ?? [];
    final filteredDepartmentGroups = departmentGroups.where((group) => group.groupName != "미선택").toList();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '본전공을 선택해 주세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              hint: Text('대분류를 선택해 주세요'),
              value: selectedGroup1,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGroup1 = newValue;
                  selectedDepartment1 = null;
                });
              },
              items: filteredDepartmentGroups.map<DropdownMenuItem<String>>((DepartmentGroup group) {
                return DropdownMenuItem<String>(
                  value: group.groupName,
                  child: Text(group.groupName),
                );
              }).toList(),
            ),
            if (selectedGroup1 != null)
              DropdownButton<Department>(
                hint: Text('소분류를 선택해 주세요'),
                value: selectedDepartment1,
                onChanged: (Department? newValue) {
                  setState(() {
                    selectedDepartment1 = newValue;
                  });
                  ref.read(signupProvider.notifier).updateMajor1(newValue?.title ?? '');
                },
                items: filteredDepartmentGroups
                    .firstWhere((group) => group.groupName == selectedGroup1!)
                    .departments
                    .map<DropdownMenuItem<Department>>((Department department) {
                  return DropdownMenuItem<Department>(
                    value: department,
                    child: Text(department.title),
                  );
                }).toList(),
              ),
            SizedBox(height: 16.0),
            Text(
              '복수전공 선택 (선택사항)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            DropdownButton<String>(
              hint: Text('대분류를 선택해 주세요'),
              value: selectedGroup2,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGroup2 = newValue;
                  selectedDepartment2 = null;
                });
              },
              items: departmentGroups.map<DropdownMenuItem<String>>((DepartmentGroup group) {
                return DropdownMenuItem<String>(
                  value: group.groupName,
                  child: Text(group.groupName),
                );
              }).toList(),
            ),
            if (selectedGroup2 != null)
              DropdownButton<Department>(
                hint: Text('소분류를 선택해 주세요'),
                value: selectedDepartment2,
                onChanged: (Department? newValue) {
                  setState(() {
                    selectedDepartment2 = newValue;
                  });
                  ref.read(signupProvider.notifier).updateMajor2(newValue?.title ?? '');
                },
                items: departmentGroups
                    .firstWhere((group) => group.groupName == selectedGroup2!)
                    .departments
                    .map<DropdownMenuItem<Department>>((Department department) {
                  return DropdownMenuItem<Department>(
                    value: department,
                    child: Text(department.title),
                  );
                }).toList(),
              ),
            Spacer(),
            ElevatedButton(
              onPressed: selectedDepartment1 != null ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupCompleteScreen(),
                  ),
                );
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedDepartment1 != null ? Color(0xFFAA71D8) : Colors.grey,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}
