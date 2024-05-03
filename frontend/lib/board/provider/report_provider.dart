import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

import '../../common/const/data.dart';

part 'report_provider.g.dart';

final reportProvider = Provider<Report>((ref) {
  final dio = ref.watch(dioProvider);

  return Report(dio, baseUrl: ip);
});

@RestApi()
abstract class Report {
  factory Report(Dio dio, {String baseUrl}) = _Report;

  @POST('/api/report')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> post(
    @Body() Map<String, dynamic> data,
  );
}
