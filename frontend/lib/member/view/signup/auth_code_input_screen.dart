import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/member/view/signup/password_input_screen.dart';

import '../../provider/signup_provider.dart';

class AuthCodeInputScreen extends ConsumerStatefulWidget {
  @override
  _AuthCodeInputScreenState createState() => _AuthCodeInputScreenState();
}

class _AuthCodeInputScreenState extends ConsumerState<AuthCodeInputScreen> {
  bool isAuthNumberValid = true;

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupProvider);

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
              onPressed: signupState.authNumber.isNotEmpty
                  ? () {
                      // Validate auth number logic
                      setState(() {
                        isAuthNumberValid = signupState.authNumber ==
                            '123456'; // Example validation
                      });
                      if (isAuthNumberValid) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PasswordInputScreen(),
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: signupState.authNumber.isNotEmpty
                    ? Color(0xFFAA71D8)
                    : Colors.grey,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '확인',
                style: TextStyle(color: signupState.authNumber.isNotEmpty? Colors.white : Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
