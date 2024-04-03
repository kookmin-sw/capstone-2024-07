import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/colors.dart';

import '../model/member_model.dart';
import '../provider/member_state_notifier_provider.dart';

class MyInfoScreen extends ConsumerStatefulWidget {
  const MyInfoScreen({super.key});

  @override
  ConsumerState<MyInfoScreen> createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends ConsumerState<MyInfoScreen> {
  bool isWillingToChangeMajor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _renderTop(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                child: Column(
                  children: [
                    _renderMyInfo(),
                    if (!isWillingToChangeMajor)
                      _renderButton(
                        "전공 변경하기",
                            () {
                          setState(() {
                            isWillingToChangeMajor = true;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderTop() {
    return Container(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
            ),
          ),
          const SizedBox(width: 113.0),
          Text(
            "내 정보",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderMyInfo() {
    final memberState = ref.watch(memberStateNotifierProvider);

    String nickname = "";
    String universityName = "";
    String email = "";
    String major = "";
    String minor = "";

    if (memberState is MemberModel) {
      nickname = memberState.nickname;
      universityName = memberState.universityName;
      email = memberState.email;
      major = memberState.major;
      minor = memberState.minor;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(color: BODY_TEXT_COLOR),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      height: 170.0,
      child: Column(
        children: [
          _renderSimpleTextBox('닉네임', nickname, 10),
          _renderSimpleTextBox('학교', universityName, 20),
          _renderSimpleTextBox('이메일', email, 10),
          _renderSimpleTextBox('전공', major, 22),
          _renderSimpleTextBox('부전공', minor, 9),
        ],
      ),
    );
  }

  Widget _renderSimpleTextBox(String fieldName, String content, double size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Text(
            fieldName,
          ),
          SizedBox(width: size),
          Text(
            content,
            style: const TextStyle(
              color: BODY_TEXT_COLOR,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderButton(String text, VoidCallback onButtonClicked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
          minimumSize: Size(
            MediaQuery.of(context).size.width,
            50.0,
          ),
        ),
        onPressed: onButtonClicked,
        child: Text(text),
      ),
    );
  }
}
