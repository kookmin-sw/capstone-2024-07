import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../common/component/notice_popup_dialog.dart';
import '../../../common/const/data.dart';
import '../../../common/provider/dio_provider.dart';
import '../../provider/signup_provider.dart';
import 'password_input_screen.dart';

class AuthCodeInputScreen extends ConsumerStatefulWidget {
  @override
  _AuthCodeInputScreenState createState() => _AuthCodeInputScreenState();
}

class _AuthCodeInputScreenState extends ConsumerState<AuthCodeInputScreen> {
  bool isAuthNumberValid = true;

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupProvider);
    final dio = ref.read(dioProvider);

    void verifyAuthCode() async {
      try {
        final response = await dio.post(
          '$ip/api/users/authenticate-email',
          queryParameters: {
            'email': signupState.email,
            'authenticationCode': signupState.authNumber
          },
        );

        if (response.statusCode == 204) {
          setState(() {
            isAuthNumberValid = true;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PasswordInputScreen(),
            ),
          );
        } else {
          setState(() {
            isAuthNumberValid = false;
          });
        }
      } on DioException catch (e) {
        setState(() {
          isAuthNumberValid = false;
        });
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
        setState(() {
          isAuthNumberValid = false;
        });
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
              '인증번호를 입력해 주세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              '사용하실 이메일 주소로 인증번호를 전송하였습니다.',
              style: TextStyle(fontSize: 14, color: Colors.black45),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: '인증번호',
                errorText: !isAuthNumberValid ? '인증번호를 다시 확인해주세요.' : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                ref.read(signupProvider.notifier).updateAuthNumber(value);
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: signupState.authNumber.isNotEmpty ? verifyAuthCode : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: signupState.authNumber.isNotEmpty ? Color(0xFFAA71D8) : Colors.grey,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '확인',
                style: TextStyle(color: signupState.authNumber.isNotEmpty ? Colors.white : Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
