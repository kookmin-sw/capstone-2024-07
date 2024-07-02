import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/signup_provider.dart';
import 'email_input_screen.dart';

class NameNicknameInputScreen extends ConsumerWidget {
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
            Text(
              '이름과 닉네임을 입력해 주세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: '이름(본명)을 입력해주세요.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                ref.read(signupProvider.notifier).updateName(value);
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: '닉네임을 입력해주세요.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                ref.read(signupProvider.notifier).updateNickname(value);
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: signupState.name.isNotEmpty && signupState.nickname.isNotEmpty
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmailInputScreen(),
                  ),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: signupState.name.isNotEmpty && signupState.nickname.isNotEmpty ? Color(0xFFAA71D8) : Colors.grey,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '다음',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
