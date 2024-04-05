import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/comment_model.dart';
import 'package:frontend/board/model/comment_response_model.dart';
import 'package:frontend/common/const/data.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

part 'comment_provider.g.dart';

final commentProvider = Provider<CommentNotifier>((ref) {
  final dio = ref.watch(dioProvider);

  return CommentNotifier(dio, baseUrl: 'http://$ip');
});

@RestApi()
abstract class CommentNotifier {
  factory CommentNotifier(Dio dio, {String baseUrl}) = _CommentNotifier;

  @GET('/api/comments/{postId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<CommentModel>> get(
    @Path('postId') String postId,
  );

  @POST('/api/comments')
  @Headers({
    'accessToken': 'true',
  })
  Future<CommentResponseModel> post(
    @Body() Map<String, dynamic> data,
  );

  @POST('/api/comments/likes')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> heart(
    @Body() Map<String, dynamic> data,
  );

  @PUT('/api/comments/{commentId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> modify(
    @Path() int commentId,
    @Body() Map<String, dynamic> data,
  );

  @DELETE('/api/comments/{commentId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> delete(
    @Path() int commentId,
  );
}
