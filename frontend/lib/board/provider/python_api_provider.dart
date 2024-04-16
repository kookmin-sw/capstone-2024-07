import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/python_response_model.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

import '../../common/const/data.dart';

part 'python_api_provider.g.dart';

final pythonApiRepository = Provider<PythonAPI>((ref) {
  final dio = ref.watch(dioProvider);

  return PythonAPI(dio, baseUrl: pythonIP);
});

@RestApi()
abstract class PythonAPI {
  factory PythonAPI(Dio dio, {String baseUrl}) = _PythonAPI;

  @POST('')
  @Headers({
    'accessToken': 'true',
  })
  Future<PythonResponseModel> post(
    @Body() String message,
  );
}
