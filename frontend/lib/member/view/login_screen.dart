import 'package:flutter/material.dart';
import 'package:frontend/member/view/signup_screen.dart';

import '../../common/const/colors.dart';
import '../../common/layout/default_layout.dart';
import '../component/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'DeCl',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w500,
                      color: PRIMARY_COLOR,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                _renderTitle(),
                _renderSubTitle(),
                const SizedBox(height: 16.0),
                Image.asset(
                  'asset/imgs/students.jpeg', // 임시로 ai로 만든 이미지 넣어둠.. 추후 변경 예정
                  width: MediaQuery.of(context).size.width / 2,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요.',
                  onChanged: (String value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: (){
                    print("login pressed!");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: Text(
                    '로그인',
                  ),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SignupScreen(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(PRIMARY_COLOR),
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: PRIMARY_COLOR,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderTitle(){
    return const Text(
      '학과별 정보공유 커뮤니티, 디클',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _renderSubTitle(){
    return Text(
      '학교 이메일과 비밀번호를 입력해서 로그인 해주세요!',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
