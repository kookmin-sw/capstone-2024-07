import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';

import '../../common/component/notice_popup_dialog.dart';
import '../../common/const/colors.dart';
import '../../common/const/data.dart';
import '../../common/provider/dio_provider.dart';
import '../component/custom_text_form_field.dart';

class PasswordEditScreen extends ConsumerStatefulWidget {
  const PasswordEditScreen({super.key});

  @override
  ConsumerState<PasswordEditScreen> createState() => _PasswordEditScreenState();
}

class _PasswordEditScreenState extends ConsumerState<PasswordEditScreen> {
  String oldPassword = "";
  String password = "";
  String password2 = "";

  bool isPasswordNull = true;
  bool isPasswordDifferent = false;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _renderTop(),
                const SizedBox(height: 10.0),
                _renderPasswordField(),
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
                '비밀번호 변경',
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

  Widget _renderPasswordField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('현재 비밀번호'),
          const SizedBox(height: 6.0),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CustomTextFormField(
              isInputEnabled: true,
              obscureText: true,
              hintText: '현재 비밀번호를 입력해주세요.',
              onChanged: (String value) {
                oldPassword = value;
                setState(() {
                  isPasswordNull =
                      (password == '' && password2 == '') ? true : false;
                });
              },
            ),
          ),
          const SizedBox(height: 16.0),
          const Text('새로운 비밀번호'),
          const SizedBox(height: 6.0),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CustomTextFormField(
              isInputEnabled: true,
              obscureText: true,
              hintText: '새로운 비밀번호를 입력해주세요.',
              onChanged: (String value) {
                password = value;
                setState(() {
                  isPasswordDifferent = password == password2 ? false : true;
                  isPasswordNull =
                      (password == '' && password2 == '') ? true : false;
                });
              },
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CustomTextFormField(
              isInputEnabled: true,
              obscureText: true,
              hintText: '새로운 비밀번호를 한번 더 입력해주세요.',
              onChanged: (String value) {
                password2 = value;
                setState(() {
                  isPasswordDifferent = password == password2 ? false : true;
                  isPasswordNull =
                      (password == '' && password2 == '') ? true : false;
                });
              },
            ),
          ),
          if (isPasswordNull)
            const Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '비밀번호는 빈칸일 수 없습니다.',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          if (isPasswordDifferent)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '비밀번호가 일치하지 않습니다.',
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
        if (!isPasswordNull && !isPasswordDifferent) {
          try {
            final resp = await dio.post(
              '$ip/api/users/edit-password',
              data: {
                'oldPassword': oldPassword,
                'password': password,
                'confirmPassword': password2,
              },
            );
            if (resp.statusCode == 204) {
              showDialog(
                context: context,
                builder: (context) {
                  return NoticePopupDialog(
                    message: "비밀번호 변경이 완료되었습니다.",
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
      child: const Text(
        '비밀번호 변경',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
