import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:retrofit/http.dart';
import '../../common/const/data.dart';

part 'scrap_provider.g.dart';

final scrapProvider = Provider<Scrap>((ref) {
  final dio = ref.watch(dioProvider);

  return Scrap(dio, baseUrl: 'http://$ip');
});

@RestApi()
abstract class Scrap {
  factory Scrap(Dio dio, {String baseUrl}) = _Scrap;

  @POST('/api/scrap')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> post(
    @Query('postId') int postId,
  );

  @DELETE('/api/scrap/{postId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> delete(
    @Path('postId') int postId,
  );
}
