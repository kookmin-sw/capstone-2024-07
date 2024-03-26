import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/member/provider/selected_major_provider.dart';

import '../../common/const/data.dart';
import '../../common/provider/secure_storage_provider.dart';
import '../model/member_model.dart';
import 'auth_repository_provider.dart';
import 'member_repository_provider.dart';

final memberStateNotifierProvider = StateNotifierProvider<MemberStateNotifier, MemberModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final memberRepository = ref.watch(memberRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return MemberStateNotifier(
    authRepository: authRepository,
    memberRepository: memberRepository,
    storage: storage,
    ref: ref,
  );
});

class MemberStateNotifier extends StateNotifier<MemberModelBase?> {
  final AuthRepository authRepository;
  final MemberRepository memberRepository;
  final FlutterSecureStorage storage;
  final Ref ref;

  MemberStateNotifier({
    required this.authRepository,
    required this.memberRepository,
    required this.storage,
    required this.ref,
  }) : super(MemberModelLoading()) {
    //내 정보 가져오기
    getMe();
  }

  Future<void> getMe() async {
    try{
      final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
      final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

      if (refreshToken == null || accessToken == null) {
        state = null;
        return;
      }

      final resp = await memberRepository.getMe();

      //성공적으로 가져왔을 경우 MemberModel이 state에 담기게 된다.
      state = resp;

      if (resp is MemberModel) {
        ref.read(selectedMajorProvider.notifier).state = resp.activatedDepartment;
      }
    } on DioException catch(e){
      if(e.response?.statusCode == 401){
        state = MemberModelError(message: "로그인되지 않았습니다.");
      } else{
        state = MemberModelError(message: "기타 에러..!");
      }
    }
  }

  Future<MemberModelBase> login({
    required String email,
    required String password,
  }) async {
    try {
      state = MemberModelLoading();

      final resp = await authRepository.login(
        email: email,
        password: password,
      ); //resp는 LoginResponse이다.

      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      final memberResp = await memberRepository.getMe();
      state = memberResp;

      return memberResp;
    } catch (e) {
      state = MemberModelError(message: '로그인에 실패했습니다.');
      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    await Future.wait(
      [
        storage.delete(key: REFRESH_TOKEN_KEY),
        storage.delete(key: ACCESS_TOKEN_KEY),
      ],
    );
  }
}