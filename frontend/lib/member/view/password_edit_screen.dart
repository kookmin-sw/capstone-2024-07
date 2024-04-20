import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

class PasswordEditScreen extends StatefulWidget {
  const PasswordEditScreen({super.key});

  @override
  State<PasswordEditScreen> createState() => _PasswordEditScreenState();
}

class _PasswordEditScreenState extends State<PasswordEditScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Center(
            child: Text("비밀번호 변경 페이지"),
          ),
        ),
      ),
    );
  }
}
