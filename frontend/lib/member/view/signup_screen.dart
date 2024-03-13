import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/data.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:frontend/member/component/custom_text_form_field.dart';

import '../../common/component/NoticePopupDialog.dart';
import '../../common/const/colors.dart';
import '../provider/first_major_state_notifier_provider.dart';
import '../provider/second_major_state_notifier_provider.dart';

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
  String authNumber = "";
  String major1 = "";
  String major2 = "";

  bool isAccept = false;

  //이름, 닉네임 이메일, 비밀번호, 인증번호 검증
  bool isNameNull = true;

  bool isEmailNull = true;
  bool isEmailAuthenticated = false;
  bool isEmailSend = false;

  bool isPasswordNull = true;
  bool isPasswordDifferent = false;

  bool isNicknameNull = true;
  bool isNicknameDuplicated = true;

  bool isAuthNumberNull = true;

  // 복수전공 선택 여부
  bool isDoubleMajor = false;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 40),
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
                    _renderFirstMajorField(),
                    if (!isDoubleMajor) _renderAddMajorButton(),
                    if (isDoubleMajor) _renderSecondMajorField(),
                    if (isDoubleMajor) _renderDeleteMajorButton(),
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
    final dio = ref.watch(dioProvider);

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
                  isInputEnabled: !isEmailSend,
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
                onPressed: (isEmailNull || isEmailAuthenticated)
                    ? null
                    : () async {
                        try{
                          final resp = await dio.post(
                            'http://$ip/api/users/authentication-code?email=$email',
                          );
                          if(resp.statusCode == 204){
                            setState(() {
                              isEmailSend = true;
                            });
                            showDialog(
                              context: context,
                              builder: (context) {
                                return NoticePopupDialog(
                                  message: "인증번호가 전송되었습니다.",
                                  buttonText: "닫기",
                                  onPressed: () {
                                    Navigator.pop(context); // 두 번째 팝업 닫기
                                  },
                                );
                              },
                            );
                          }
                        } on DioException catch (e){
                          showDialog(
                            context: context,
                            builder: (context) {
                              return NoticePopupDialog(
                                message: e.response?.data["message"] ?? "에러 발생",
                                buttonText: "닫기",
                                onPressed: () {
                                  Navigator.pop(context); // 두 번째 팝업 닫기
                                },
                              );
                            },
                          );
                        }
                      },
                child: Text('전송'),
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
          SizedBox(height: 16.0),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3 * 2,
                child: CustomTextFormField(
                  isInputEnabled: !isEmailAuthenticated,
                  hintText: '인증번호를 입력해주세요.',
                  onChanged: (String value) {
                    authNumber = value;
                    setState(() {
                      isAuthNumberNull = authNumber == "" ? true : false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                ),
                onPressed: (isEmailNull || isEmailAuthenticated)
                    ? null
                    : () async {
                  try{
                    final resp = await dio.post(
                      'http://$ip/api/users/authenticate-email?email=$email&authenticationCode=$authNumber',
                    );
                    if(resp.statusCode == 204){
                      setState(() {
                        isEmailAuthenticated = true;
                      });
                      showDialog(
                        context: context,
                        builder: (context) {
                          return NoticePopupDialog(
                            message: "인증이 완료되었습니다.",
                            buttonText: "닫기",
                            onPressed: () {
                              Navigator.pop(context); // 두 번째 팝업 닫기
                            },
                          );
                        },
                      );
                    }
                  } on DioException catch (e){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return NoticePopupDialog(
                          message: e.response?.data["message"] ?? "에러 발생",
                          buttonText: "닫기",
                          onPressed: () {
                            Navigator.pop(context); // 두 번째 팝업 닫기
                          },
                        );
                      },
                    );
                  }
                },
                child: Text('확인'),
              ),
            ],
          ),
          if (isAuthNumberNull)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '인증번호는 빈칸일 수 없습니다.',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _renderFirstMajorField() {
    //학과 정보
    final departmentState = ref.watch(firstDepartmentListNotifierProvider);

    String selectedDivision = departmentState.selectedDivision;
    String selectedDepartment = departmentState.selectedDepartment;

    final divisionAndDepartments = departmentState.divisionAndDepartments;

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '본전공 선택',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
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
                              .read(
                                  firstDepartmentListNotifierProvider.notifier)
                              .setSelectedDivision(value);
                          if (selectedDepartment != null) {
                            ref
                                .read(firstDepartmentListNotifierProvider
                                    .notifier)
                                .setSelectedDepartment(selectedDepartment!);
                            setState(() {
                              major1 = selectedDepartment;
                            });
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
                              .read(
                                  firstDepartmentListNotifierProvider.notifier)
                              .setSelectedDepartment(value);
                          setState(() {
                            major1 = selectedDepartment;
                          });
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderSecondMajorField() {
    //학과 정보
    final departmentState = ref.watch(secondDepartmentListNotifierProvider);

    String selectedDivision = departmentState.selectedDivision;
    String selectedDepartment = departmentState.selectedDepartment;

    final divisionAndDepartments = departmentState.divisionAndDepartments;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '복수전공 선택',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
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
                              .read(
                                  secondDepartmentListNotifierProvider.notifier)
                              .setSelectedDivision(value);
                          if (selectedDepartment != null) {
                            ref
                                .read(secondDepartmentListNotifierProvider
                                    .notifier)
                                .setSelectedDepartment(selectedDepartment!);
                            setState(() {
                              major2 = selectedDepartment;
                            });
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
                              .read(
                                  secondDepartmentListNotifierProvider.notifier)
                              .setSelectedDepartment(value);
                          setState(() {
                            major2 = selectedDepartment;
                          });
                        });
                      }
                    },
                  ),
                ),
              ],
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

  Widget _renderAddMajorButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              isDoubleMajor = true;
            });
          },
          icon: const Icon(Icons.add),
          label: Text('복수전공 추가'),
        ),
      ],
    );
  }

  Widget _renderDeleteMajorButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              isDoubleMajor = false;
              major2 = "";
            });
          },
          icon: const Icon(Icons.clear),
          label: Text('복수전공 취소'),
        ),
      ],
    );
  }
}
