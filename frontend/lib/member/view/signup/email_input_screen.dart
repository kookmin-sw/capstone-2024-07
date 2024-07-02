import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../common/component/notice_popup_dialog.dart';
import '../../../common/const/data.dart';
import '../../../common/provider/dio_provider.dart';
import '../../provider/signup_provider.dart';
import 'auth_code_input_screen.dart';

class EmailInputScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupState = ref.watch(signupProvider);
    final dio = ref.read(dioProvider);

    void sendAuthCode() async {
      try {
        final response = await dio.post(
          '$ip/api/users/authentication-code',
          queryParameters: {'email': signupState.email},
        );
        if (response.statusCode == 204) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AuthCodeInputScreen(),
            ),
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
            Text(
              '대학교 이메일을 입력해 주세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: '로그인 시 사용할 이메일을 입력해 주세요.',
                hintStyle: TextStyle(fontWeight: FontWeight.w400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                ref.read(signupProvider.notifier).updateEmail(value);
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: signupState.email.isNotEmpty ? sendAuthCode : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: signupState.email.isNotEmpty ? Color(0xFFAA71D8) : Colors.grey,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '다음',
                style: TextStyle(color: signupState.email.isNotEmpty ? Colors.white : Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
