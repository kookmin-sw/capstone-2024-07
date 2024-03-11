import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:frontend/member/component/custom_text_form_field.dart';

import '../../common/const/colors.dart';
import '../provider/department_list_notifier_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  static String get routeName => 'signup';

  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  String name = "";
  String nickname = "";
  String email = "";
  String password = "";
  String password2 = "";

  bool isAccept = false;

  //이름, 닉네임 이메일, 비밀번호 검증
  bool isNameNull = true;
  bool isEmailNull = true;
  bool isEmailAuthenticated = false;
  bool isPasswordNull = true;
  bool isPasswordDifferent = false;
  bool isNicknameNull = true;
  bool isNicknameDuplicated = true;

  @override
  Widget build(BuildContext context) {
    final dio = ref.watch(dioProvider);

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
                _renderTop(),
                const SizedBox(height: 20.0),
                Column(
                  children: [
                    _renderNameField(),
                    _renderNicknameField(),
                    _renderEmailField(),
                    _renderDepartmentField(),
                    _renderPasswordField(),
                    _renderIsAcceptCheckbox(),
                    _renderRegisterButton(),
                  ],
                ),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
              color: PRIMARY_COLOR,
            ),
          ),
          const SizedBox(
            // 정렬 나중에 다시 수정할게요!
            width: 110,
          ),
          const Text(
            'DeCl',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: PRIMARY_COLOR,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderNameField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            Padding(
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

  Widget _renderNicknameField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3 * 2,
                child: CustomTextFormField(
                  isInputEnabled: true,
                  hintText: '닉네임을 입력해주세요.',
                  onChanged: (String value) {
                    nickname = value;
                    setState(() {
                      isNicknameNull = nickname == "" ? true : false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                ),
                onPressed: () {
                  print("pressed!");
                },
                child: Text('확인'),
              ),
            ],
          ),
          if (isNicknameNull)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '닉네임은 빈칸일 수 없습니다.',
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
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3 * 2,
                child: CustomTextFormField(
                  isInputEnabled: true,
                  hintText: '대학교 이메일을 입력해주세요.',
                  onChanged: (String value) {
                    email = value;
                    setState(() {
                      isEmailNull = email == "" ? true : false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                ),
                onPressed: () {
                  print("pressed!");
                },
                child: Text('확인'),
              ),
            ],
          ),
          if (isEmailNull)
            Padding(
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

  Widget _renderDepartmentField() {
    //학과 정보
    final departmentState = ref.watch(departmentListNotifierProvider);

    String selectedDivision = departmentState.selectedDivision;
    String selectedDepartment = departmentState.selectedDepartment;

    final divisionAndDepartments = departmentState.divisionAndDepartments;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 180,
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedDivision,
            items: divisionAndDepartments.keys == null
                ? []
                : divisionAndDepartments.keys
                .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ))
                .toList(),
            onChanged: (String? value) {
              if (value != null &&
                  divisionAndDepartments.containsKey(value)) {
                setState(() {
                  selectedDivision = value;
                  selectedDepartment =
                  divisionAndDepartments[value]!.isNotEmpty
                      ? divisionAndDepartments[value]![0]
                      : null;
                  ref
                      .read(departmentListNotifierProvider
                      .notifier)
                      .setSelectedDivision(value);
                  if (selectedDepartment != null) {
                    ref
                        .read(departmentListNotifierProvider
                        .notifier)
                        .setSelectedDepartment(
                        selectedDepartment!);
                  }
                });
              }
            },
          ),
        ),
        Container(
          width: 180,
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedDepartment,
            items: divisionAndDepartments[selectedDivision] == null
                ? []
                : List<String>.from(
                divisionAndDepartments[selectedDivision])
                .map((e) => DropdownMenuItem(
              value: e.toString(),
              child: Text(e.toString()),
            ))
                .toList(),
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  selectedDepartment = value;
                  ref
                      .read(departmentListNotifierProvider
                      .notifier)
                      .setSelectedDepartment(value);
                });
              }
            },
          ),
        ),
      ],
    );
  }


  Widget _renderPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CustomTextFormField(
              isInputEnabled: true,
              obscureText: true,
              hintText: '비밀번호를 입력해주세요.',
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
              hintText: '비밀번호를 한번 더 입력해주세요.',
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
            Padding(
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

  Widget _renderIsAcceptCheckbox() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        children: [
          Text('개인정보 수집 및 이용 동의'),
          Checkbox(
            activeColor: PRIMARY_COLOR,
            value: isAccept,
            onChanged: (bool? value) {
              setState(() {
                isAccept = value ?? false;
              });
            },
          ),
          TextButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: PRIMARY_COLOR,
                minimumSize: Size(80.0, 30.0),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text('개인정보 수집 및 이용동의 관련 내용'),
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: Text('닫기'),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('내용 확인')),
        ],
      ),
    );
  }

  Widget _renderRegisterButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: PRIMARY_COLOR,
        minimumSize: Size(
          MediaQuery.of(context).size.width,
          50.0,
        ),
      ),
      onPressed: () async {
        if (!isEmailNull &&
            isEmailAuthenticated &&
            !isPasswordNull &&
            !isPasswordDifferent &&
            !isNicknameNull &&
            !isNicknameDuplicated &&
            isAccept) {
          // 회원가입 api 요청..

          // try {
          //   final resp = await dio.post(
          //     'http://$ip/signup',
          //     data: {
          //       'email': email,
          //       'password': password,
          //       'nickname': nickname,
          //       'univName': univName,
          //       'isAccept': isAccept,
          //       'isEmailAuthenticated': isEmailAuthenticated,
          //     },
          //     options: Options(
          //       headers: {'Content-Type': 'application/json'},
          //     ),
          //   );
          //   if (resp.statusCode == 200) {
          //     //리다이렉트 로직 다시 짜기!
          //     getSignupResultDialog(context, "회원가입이 완료되었습니다.");
          //   }
          // } catch (e) {
          //   getNoticeDialog(context, e.toString());
          // }
        }
      },
      child: Text('회원가입하기'),
    );
  }
}
