import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';

import '../../common/component/notice_popup_dialog.dart';
import '../../common/const/colors.dart';
import '../../common/const/data.dart';
import '../../common/provider/dio_provider.dart';
import '../component/custom_text_form_field.dart';

class PasswordResetScreen extends ConsumerStatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  ConsumerState<PasswordResetScreen> createState() =>
      _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  bool isNameNull = true;
  bool isEmailNull = true;

  String name = "";
  String email = "";

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _renderTop(),
                const SizedBox(height: 10.0),
                _renderInfo(),
                const SizedBox(height: 30.0),
                _renderNameField(),
                _renderEmailField(),
                const SizedBox(height: 20.0),
                _renderButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderTop() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.chevron_left,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Center(
              child: Text(
                '비밀번호 초기화',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderInfo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '비밀번호를 분실하셨나요?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Text(
          '이름과 학교 이메일을 입력하시면 새로운 비밀번호를 이메일로 전송해드립니다.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _renderNameField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('이름'),
          const SizedBox(height: 6.0),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CustomTextFormField(
              isInputEnabled: true,
              hintText: '이름(본명)을 입력해주세요.',
              onChanged: (String value) {
                name = value;
                setState(() {
                  isNameNull = name == "" ? true : false;
                });
              },
            ),
          ),
          if (isNameNull)
            const Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '이름은 빈칸일 수 없습니다.',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _renderEmailField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('이메일'),
          const SizedBox(height: 6.0),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CustomTextFormField(
              isInputEnabled: true,
              hintText: '이메일을 입력해주세요.',
              onChanged: (String value) {
                email = value;
                setState(() {
                  isEmailNull = email == "" ? true : false;
                });
              },
            ),
          ),
          if (isEmailNull)
            const Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '이메일은 빈칸일 수 없습니다.',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _renderButton() {
    final dio = ref.watch(dioProvider);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: PRIMARY_COLOR,
        textStyle: const TextStyle(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        minimumSize: Size(
          MediaQuery.of(context).size.width,
          50.0,
        ),
      ),
      onPressed: () async {
        if (!isEmailNull && !isNameNull) {
          try {
            final resp = await dio.post(
              '$ip/api/users/reset-password',
              data: {
                'name': name,
                'email': email,
              },
            );
            if (resp.statusCode == 204) {
              showDialog(
                context: context,
                builder: (context) {
                  return NoticePopupDialog(
                    message: "새로운 비밀번호를 이메일로 전송했습니다.",
                    buttonText: "닫기",
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
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
                  message: e.response?.data["message"] ?? "에러가 발생했습니다.",
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
                  message: "에러가 발생했습니다.",
                  buttonText: "닫기",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        }
      },
      child: Text(
        '비밀번호 초기화',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700
        ),
      ),
    );
  }
}
