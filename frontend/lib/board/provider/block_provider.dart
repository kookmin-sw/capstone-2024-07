import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

import '../../common/const/data.dart';

part 'block_provider.g.dart';

final blockProvider = Provider<Block>((ref) {
  final dio = ref.watch(dioProvider);

  return Block(dio, baseUrl: ip);
});

@RestApi()
abstract class Block {
  factory Block(Dio dio, {String baseUrl}) = _Block;

  @POST('/api/block')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> post(
    @Query('blockedUserId') int blockedUserId,
  );
}
