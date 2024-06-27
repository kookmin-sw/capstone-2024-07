import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/signup_provider.dart';

class SignupCompleteScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupState = ref.watch(signupProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('이메일: ${signupState.email}'),
            Text('비밀번호: ${signupState.password}'),
            Text('본전공: ${signupState.major1}'),
            Text('복수전공: ${signupState.major2.isNotEmpty ? signupState.major2 : "없음"}'),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                final String major1 = signupState.major1;
                final String major2 = signupState.major2.isNotEmpty ? signupState.major2 : "";

                // 회원가입 api요청
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAA71D8),
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('회원가입하기'),
            ),
          ],
        ),
      ),
    );
  }
}
