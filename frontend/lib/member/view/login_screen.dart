import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/member/view/password_reset_screen.dart';
import 'package:frontend/member/view/signup_screen.dart';

import '../../common/component/notice_popup_dialog.dart';
import '../../common/const/colors.dart';
import '../../common/layout/default_layout.dart';
import '../component/custom_text_form_field.dart';
import '../model/member_model.dart';
import '../provider/member_state_notifier_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isWillingToResetPassword = false;
  String email = '';
  String password = '';

  void getNoticeDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return NoticePopupDialog(
          message: message,
          buttonText: "닫기",
          onPressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(memberStateNotifierProvider);

    if (state is MemberModelError) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        getNoticeDialog(context, state.message);
      });
    }

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: Image.asset(
                      'asset/imgs/logo.png',
                      width: 80.0,
                    ),
                  ),
                ),
                _renderTitle(),
                _renderSubTitle(),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 50.0, 12.0, 50.0),
                  child: Container(
                    width: 220.0,
                    height: 220.0,
                    child: Image.asset(
                      'asset/imgs/decle.png',
                    ),
                  ),
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요.',
                  onChanged: (String value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: state is MemberModelLoading //로딩중이면 로그인 버튼 못누르도록
                        ? null
                        : () async {
                            ref
                                .read(memberStateNotifierProvider.notifier)
                                .login(email: email, password: password);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      '로그인',
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  height: 40.0,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SignupScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(PRIMARY_COLOR),
                      side: MaterialStateProperty.all(
                        const BorderSide(
                          color: PRIMARY_COLOR,
                          width: 1.0,
                        ),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    child: const Text('회원가입'),
                  ),
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  height: 40.0,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PasswordResetScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(BODY_TEXT_COLOR),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    child: const Text('비밀번호 초기화'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderTitle() {
    return const Text(
      '학과별 정보공유 커뮤니티, 디클',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _renderSubTitle() {
    return const Text(
      '학교 이메일과 비밀번호를 입력해서 로그인 해주세요!',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
