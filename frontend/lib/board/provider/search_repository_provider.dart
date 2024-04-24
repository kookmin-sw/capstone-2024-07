import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

import '../../common/const/data.dart';
import '../model/msg_board_response_model.dart';

part 'search_repository_provider.g.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return SearchRepository(dio, baseUrl: ip);
});

@RestApi()
abstract class SearchRepository {
  factory SearchRepository(Dio dio, {String baseUrl}) = _SearchRepository;

  @GET('/api/post')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPaginationModel<MsgBoardResponseModel>> paginate(
    @Query('lastId') int lastId,
    @Query('size') int size,
    @Query('keyword') String keyword,
  );
}
