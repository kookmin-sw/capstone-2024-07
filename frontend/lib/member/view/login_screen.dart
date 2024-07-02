import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/member/view/password_reset_screen.dart';
import 'package:frontend/member/view/signup/name_nickname_input_screen.dart';

import '../../common/component/notice_popup_dialog.dart';
import '../../common/const/colors.dart';
import '../../common/layout/default_layout.dart';
import '../model/member_model.dart';
import '../provider/member_state_notifier_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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

  void onContactPressed() async {
    final Email email = Email(
        body: '문의할 사항을 아래에 작성해주세요.',
        subject: '[디클 문의]',
        recipients: ['99jiasmin@gmail.com'],
        cc: [],
        bcc: [],
        attachmentPaths: [],
        isHTML: false);

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      getNoticeDialog(
          context, '기본 메일 앱을 사용할 수 없습니다. \n이메일로 연락주세요! 99jiasmin@gmail.com');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(memberStateNotifierProvider);

    // 로그인 오류가 났을 경우엔 팝업으로 알림보내기
    if (state is MemberModelError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getNoticeDialog(context, state.message);
      });
    }

    return DefaultLayout(
      child: SingleChildScrollView(
        // SingleChildScrollView -> 화면 크기를 늘려주는것
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        // keyboardDismissBehavior = 스크롤을 움직이면 올라왔던 키보드가 바로 다시 내려가게 함..
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 120.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'asset/imgs/logo.png',
                      width: 140,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      '학과끼리 통하는 이야기, 디클',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: '학교 이메일을 입력해주세요.',
                    hintStyle: TextStyle(fontWeight: FontWeight.w400),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: PRIMARY_COLOR,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (String value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: '비밀번호를 입력해주세요.',
                    hintStyle: TextStyle(fontWeight: FontWeight.w400),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: PRIMARY_COLOR,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  obscureText: true,
                  onChanged: (String value) {
                    password = value;
                  },
                ),
                const SizedBox(height: 30.0),
                Container(
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: state is MemberModelLoading // 로딩 중이면 로그인 버튼 비활성화
                        ? null
                        : () async {
                            await ref
                                .read(memberStateNotifierProvider.notifier)
                                .login(email: email, password: password);
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: PRIMARY_COLOR,
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 40.0,
                  child: TextButton(
                    onPressed:
                        state is MemberModelLoading // 로딩 중이면 회원가입 버튼 비활성화
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => NameNicknameInputScreen(),
                                  ),
                                );
                              },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: PRIMARY_COLOR),
                        ),
                      ),
                      foregroundColor: MaterialStateProperty.all(PRIMARY_COLOR),
                    ),
                    child: Text(
                      '회원가입',
                      style: TextStyle(color: PRIMARY_COLOR),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PasswordResetScreen(),
                          ),
                        );
                      },
                      child: Text(
                        '비밀번호 분실',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.circle,
                        color: Colors.grey,
                        size: 5.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: onContactPressed,
                      child: Text(
                        '문의하기',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
