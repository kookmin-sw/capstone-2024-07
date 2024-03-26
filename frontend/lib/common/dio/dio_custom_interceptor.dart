import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../const/data.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;
  final Dio dio;

  // 리프레쉬 토큰을 새로 발급받고 있으면 대기열에서 기다렸다가 요청을 처리하도록 한다.
  bool isRefreshing = false;
  List<ErrorInterceptorHandler> requestQueue = [];

  CustomInterceptor(
      this.storage,
      this.ref,
      this.dio,
      );

  // 1) 요청을 보낼 때
  // 요청이 보내질때마다 요청 Header에 accessToken: true라는 값이 있다면 실제 토큰을 스토리지에서 가져와서 담아서 보내준다.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] [${options.uri}]');

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken'); //헤더 삭제

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({
        'Authorization': 'Bearer $token', //실제 토큰으로 대체
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken'); //헤더 삭제

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'Authorization': 'Bearer $token', //실제 토큰으로 대체
      });
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] [${response.requestOptions.uri}]');
    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을 때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러가 났을 때 -> 토큰을 재발급받는 시도를 하고, 토큰이 재발급되면 다시 새로운 토큰으로 요청을 한다.
    print('[ERR] [${err.requestOptions.method}] [${err.requestOptions.uri}]');
    print('에러메시지: ${err.message}');
    print('헤더: ${err.requestOptions.headers}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken이 아예 없으면 에러를 던진다.
    // 에러를 던질때는 handler.reject를 사용한다.
    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    // 나중에 백엔드 예외처리되면 적절하게 수정!

    // 토큰을 새로 발급받으려다가 에러가 난거라면 refreshToken 자체에 문제가 있다!
    final isPathRefresh = err.requestOptions.path == '/api/users/reissue-token';

    if (isStatus401 && !isPathRefresh) {
      RequestOptions options = err.requestOptions;

      if (!isRefreshing) {
        isRefreshing = true;
        getNewToken().then((newTokenAvailable) async {
          if (newTokenAvailable) {
            final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
            requestQueue.forEach(
                  (handler) {
                options.headers.addAll({
                  'Authorization': 'Bearer $accessToken',
                });
                dio.fetch(options).then(
                      (response) => handler.resolve(response),
                  onError: (e) => handler.reject(e),
                );
              },
            );
          } else{
            requestQueue.forEach((handler) {
              handler.reject(err);
            });
            //로그아웃 처리
            // ref.read(authProvider.notifier).logout();
          }
          requestQueue.clear();
          isRefreshing = false;
        });
      }
      //isRefreshing이 true면 대기열에 들어가 기다린다.
      requestQueue.add(handler);
    } else{
      return super.onError(err, handler);
    }
  }

  Future<bool> getNewToken() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    final dio = Dio();
    print('보내는 refreshToken: $refreshToken');
    try {
      final resp = await dio.post(
        'http://$ip/api/users/reissue-token',
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );

      // 새로 받아온 accessToken, refreshToken을 스토리지에 저장
      final newRefreshToken = resp.data['refreshToken'];
      final newAccessToken = resp.data['accessToken'];

      print('받은 refreshToken: $newRefreshToken');
      print('받은 accessToken: $newAccessToken');

      if (newRefreshToken == null || newAccessToken == null) {
        print("token null!!!");
      }

      await storage.write(key: REFRESH_TOKEN_KEY, value: newRefreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: newAccessToken);

      return true;
    } on DioException catch (e) {
      return false;
    }
  }
}