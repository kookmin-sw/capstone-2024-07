import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/recruitment_comment_model.dart';
import 'package:frontend/board/model/recruitment_comment_response_model.dart';
import 'package:frontend/common/const/data.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

part 'recruitment_comment_provider.g.dart';

final recruitmentCommentProvider = Provider<RecruitmentCommentNotifier>((ref) {
  final dio = ref.watch(dioProvider);

  return RecruitmentCommentNotifier(dio, baseUrl: ip);
});

@RestApi()
abstract class RecruitmentCommentNotifier {
  factory RecruitmentCommentNotifier(Dio dio, {String baseUrl}) =
      _RecruitmentCommentNotifier;

  @GET('/api/recruitment-comments')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPaginationModel<RecruitmentCommentModel>> paginate(
    @Query('recruitmentId') int recruitmentId,
    @Query('lastCommentId') int lastCommentId,
    @Query('size') int size,
  );

  @POST('/api/recruitment-comments')
  @Headers({
    'accessToken': 'true',
  })
  Future<RecruitmentCommentResponseModel> post(
    @Body() Map<String, dynamic> data,
  );

  @PUT('/api/recruitment-comments/{commentId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> modify(
    @Path() int commentId,
    @Body() Map<String, dynamic> data,
  );

  @DELETE('/api/recruitment-comments/{commentId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> delete(
    @Path() int commentId,
  );
}
