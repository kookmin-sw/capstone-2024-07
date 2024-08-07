import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/data.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

part 'recruitment_reply_provider.g.dart';

final recruitmentReplyProvider = Provider<RecruitmentReplyNotifier>((ref) {
  final dio = ref.watch(dioProvider);

  return RecruitmentReplyNotifier(dio, baseUrl: ip);
});

@RestApi()
abstract class RecruitmentReplyNotifier {
  factory RecruitmentReplyNotifier(Dio dio, {String baseUrl}) =
      _RecruitmentReplyNotifier;

  @POST('/api/recruitment-replies')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> post(
    @Body() Map<String, dynamic> data,
  );

  @PUT('/api/recruitment-replies/{replyId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> modify(
    @Path() int replyId,
    @Body() Map<String, dynamic> data,
  );

  @DELETE('/api/recruitment-replies/{replyId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> delete(
    @Path() int replyId,
  );
}
