import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/data.dart';
import '../../common/model/login_response.dart';
import '../../common/model/token_response.dart';
import '../../common/provider/dio_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return AuthRepository(
    baseUrl: 'http://$ip',
    dio: dio,
  );
});

class AuthRepository {
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.baseUrl,
    required this.dio,
  });

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final resp = await dio.post(
      '$baseUrl/api/users/login',
      data: {'email': email, 'password': password},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    return LoginResponse.fromJson(resp.data);
  }

  Future<TokenResponse> token() async {
    final resp = await dio.post(
      '$baseUrl/api/users/reissue-token',
      options: Options(
        headers: {
          'refreshToken': 'true',
        },
      ),
    );

    return TokenResponse.fromJson(resp.data);
  }
}
