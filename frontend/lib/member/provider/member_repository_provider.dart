import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/data.dart';
import '../../common/provider/dio_provider.dart';
import '../model/member_model.dart';

final memberRepositoryProvider = Provider<MemberRepository>(
      (ref) {
    final dio = ref.watch(dioProvider);

    return MemberRepository(baseUrl: 'http://$ip', dio: dio);
  },
);

class MemberRepository{
  final String baseUrl;
  final Dio dio;

  MemberRepository({
    required this.baseUrl,
    required this.dio,
  });

  Future<MemberModel> getMe() async {
    final resp = await dio.get(
      '$baseUrl/api/users/me',
      options: Options(
        headers: {
          'accessToken': 'true',
        },
      ),
    );

    return MemberModel.fromJson(resp.data['body']);
  }
}