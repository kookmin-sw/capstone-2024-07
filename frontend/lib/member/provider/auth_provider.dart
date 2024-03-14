import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/view/msg_board_list_screen.dart';
import 'package:go_router/go_router.dart';

import '../../common/view/splash_screen.dart';
import '../model/member_model.dart';
import '../view/login_screen.dart';
import 'member_state_notifier_provider.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    //memberStateNotifierProvider를 listen하면 유저의 로그인 상태를 알 수 있다.
    ref.listen<MemberModelBase?>(memberStateNotifierProvider, (previous, next) {
      if (previous != next) {
        // 변경사항이 있을때만
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
      path: '/boardList',
      name: MsgBoardListScreen.routeName,
      builder: (context, state) => MsgBoardListScreen(),
    ),
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (context, state) => LoginScreen(),
    ),
  ];

  void logout() {
    ref.read(memberStateNotifierProvider.notifier).logout();
  }

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final MemberModelBase? member = ref.read(memberStateNotifierProvider);

    final loggingIn = state.location == '/login';

    // 유저정보가 없는데 로그인 중이면 그대로 두고
    // 로그인 중이 아니라면 로그인 페이지로 이동.
    if (member == null) {
      print("member is null!!!");
      return loggingIn ? null : '/login';
    }

    // member가 null이 아니다. (사용자 정보가 있는 상태)

    // 1. MemberModel
    // 로그인 중이거나 현재 위치가 SplashScreen이면 홈으로 이동
    if (member is MemberModel) {
      return loggingIn || state.location == '/splash' ? '/boardList' : null;
    }

    // 2. MemberModelError
    // 로그인 하던게 아니라면 로그인 페이지로 이동
    if (member is MemberModelError) {
      return !loggingIn ? '/login' : null;
    }

    // 나머지는 원래 가던곳으로 가라!
    return null;
  }
}