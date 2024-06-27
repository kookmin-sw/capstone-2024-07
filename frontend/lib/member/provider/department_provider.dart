import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../common/const/ip_list.dart';
import '../model/department.dart';

final departmentProvider = FutureProvider<List<DepartmentGroup>>((ref) async {
  final url = '$declDomain/api/departments';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    return data.map<DepartmentGroup>((json) => DepartmentGroup.fromJson(json)).toList();
  } else {
    throw Exception('학과 api 로드 실패');
  }
});
