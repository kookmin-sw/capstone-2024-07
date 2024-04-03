import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

import '../../board/model/msg_board_response_model.dart';
import '../../common/const/data.dart';
import '../../common/model/cursor_pagination_model.dart';

part 'my_page_repository_provider.g.dart';

final myPageRepositoryProvider = Provider<MyPageRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return MyPageRepository(dio, baseUrl: 'http://$ip');
});

@RestApi()
abstract class MyPageRepository {
  factory MyPageRepository(Dio dio, {String baseUrl}) = _MyPageRepository;

  @GET('/api/post/mine')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPaginationModel<MsgBoardResponseModel>> getMyPosts(
    @Query('lastId') int lastId,
    @Query('size') int size,
  );

  @GET('/api/post/commented')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPaginationModel<MsgBoardResponseModel>> getCommentedPosts(
    @Query('lastId') int lastId,
    @Query('size') int size,
  );

  @GET('/api/post/scrapped')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPaginationModel<MsgBoardResponseModel>> getScrappedPosts(
    @Query('lastId') int lastId,
    @Query('size') int size,
  );
}
