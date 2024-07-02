import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:frontend/common/const/data.dart';

import '../../../common/component/notice_popup_dialog.dart';
import '../../../common/provider/dio_provider.dart';
import '../../provider/signup_provider.dart';
import '../login_screen.dart';

class SignupCompleteScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupState = ref.watch(signupProvider);
    final dio = ref.read(dioProvider);

    void registerUser() async {
      try {
        final response = await dio.post(
          '$ip/api/users/register',
          data: {
            'name': signupState.name,
            'email': signupState.email,
            'nickname': signupState.nickname,
            'password': signupState.password,
            'confirmPassword': signupState.confirmPassword,
            'authenticationCode': signupState.authNumber,
            'major': signupState.major1,
            'minor': signupState.major2.isNotEmpty ? signupState.major2 : "",
          },
        );
        if (response.statusCode == 200) {
          showDialog(
            context: context,
            builder: (context) {
              return NoticePopupDialog(
                message: "회원가입이 완료되었습니다.",
                buttonText: "닫기",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              );
            },
          );
        }
      } on DioException catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return NoticePopupDialog(
              message: e.response?.data["message"] ?? "에러 발생",
              buttonText: "닫기",
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return NoticePopupDialog(
              message: "알 수 없는 에러가 발생했습니다.",
              buttonText: "닫기",
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: const EdgeInsets.all(8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '회원가입 정보',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFAA71D8),
                      ),
                    ),
                    Divider(color: Color(0xFFAA71D8)),
                    SizedBox(height: 8),
                    Text(
                      '이름: ${signupState.name}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '닉네임: ${signupState.nickname}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '이메일: ${signupState.email}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '비밀번호: ${signupState.password}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '본전공: ${signupState.major1}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '복수전공: ${signupState.major2.isNotEmpty ? signupState.major2 : "없음"}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAA71D8),
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '회원가입하기',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
