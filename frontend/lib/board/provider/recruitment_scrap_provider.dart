import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:retrofit/http.dart';
import '../../common/const/data.dart';

part 'recruitment_scrap_provider.g.dart';

final recruitmentScrapProvider = Provider<RecruitmentScrap>((ref) {
  final dio = ref.watch(dioProvider);

  return RecruitmentScrap(dio, baseUrl: ip);
});

@RestApi()
abstract class RecruitmentScrap {
  factory RecruitmentScrap(Dio dio, {String baseUrl}) = _RecruitmentScrap;

  @POST('/api/recruitment/scrap')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> post(
    @Query('recruitmentId') int recruitmentId,
  );

  @DELETE('/api/recruitment/scrap/{recruitmentId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> delete(
    @Path('recruitmentId') int recruitmentId,
  );
}
