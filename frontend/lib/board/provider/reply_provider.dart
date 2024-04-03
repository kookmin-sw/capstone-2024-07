import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/data.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

part 'reply_provider.g.dart';

final replyProvider = Provider<ReplyNotifier>((ref) {
  final dio = ref.watch(dioProvider);

  return ReplyNotifier(dio, baseUrl: 'http://$ip');
});

@RestApi()
abstract class ReplyNotifier {
  factory ReplyNotifier(Dio dio, {String baseUrl}) = _ReplyNotifier;

  @POST('/api/replies')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> post(
    @Body() Map<String, dynamic> data,
  );

  @PUT('/api/replies/{replyId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> modify(
    @Path() int replyId,
    @Body() Map<String, dynamic> data,
  );

  @DELETE('/api/replies/{replyId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> delete(
    @Path() int replyId,
  );

  @POST('/api/replies/likes')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> heart(
    @Body() Map<String, dynamic> data,
  );
}
