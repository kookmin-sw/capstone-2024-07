import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

import '../../common/const/data.dart';
import '../model/msg_board_response_model.dart';

part 'board_repository_provider.g.dart';

final boardRepositoryProvider = Provider<BoardRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return BoardRepository(dio, baseUrl: 'http://$ip');
});

@RestApi()
abstract class BoardRepository {

  factory BoardRepository(Dio dio, {String baseUrl}) = _BoardRepository;
  
  @GET('/api/post')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPaginationModel<MsgBoardResponseModel>> paginate(
      @Query('lastId') int lastId,
      @Query('communityTitle') String? communityTitle,
      @Query('size') int size,
      @Query('isHot') bool isHot
      );
}
