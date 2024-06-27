import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/department.dart';

class DepartmentProvider with ChangeNotifier {
  List<DepartmentGroup> _groups = [];

  List<DepartmentGroup> get groups => _groups;

  Future<void> fetchDepartments() async {
    final url = 'https://univclass.com/api/departments';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _groups = data.map((json) => DepartmentGroup.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('학과 데이터 로드 실패');
    }
  }
}
