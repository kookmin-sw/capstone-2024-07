import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/recruitment_response_model.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

import '../../common/const/data.dart';

part 'recruitment_add_provider.g.dart';

final recruitmentAddProvider = Provider<RecruitmentAdd>((ref) {
  final dio = ref.watch(dioProvider);

  return RecruitmentAdd(dio, baseUrl: ip);
});

@RestApi()
abstract class RecruitmentAdd {
  factory RecruitmentAdd(Dio dio, {String baseUrl}) = _RecruitmentAdd;

  @GET('/api/recruitment')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPaginationModel<RecruitmentResponseModel>> paginate(
    @Query('lastId') int lastId,
    @Query('size') int size,
  );

  @PUT('/api/recruitment')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> modify(
    @Body() Map<String, dynamic> data,
  );

  @POST('/api/recruitment')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> post(
    @Body() Map<String, dynamic> data,
  );

  @DELETE('/api/recruitment/{recruitmentId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> delete(
    @Path('recruitmentId') int recruitmentId,
  );
}
