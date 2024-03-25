import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

import '../../common/const/data.dart';
import '../model/msg_board_response_model.dart';

part 'board_add_provider.g.dart';

final boardAddProvider = Provider<BoardAdd>((ref) {
  final dio = ref.watch(dioProvider);

  return BoardAdd(dio, baseUrl: 'http://$ip');
});

@RestApi()
abstract class BoardAdd {
  factory BoardAdd(Dio dio, {String baseUrl}) = _BoardAdd;

  @POST('/api/post')
  @Headers({
    'accessToken': 'true',
  })
  Future<MsgBoardResponseModel> post(
    @Body() Map<String, dynamic> data,
  );
}
