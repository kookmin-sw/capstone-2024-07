import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/data.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:frontend/member/component/custom_text_form_field.dart';
import 'package:go_router/go_router.dart';

import '../../common/component/notice_popup_dialog.dart';
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
  // bool isNicknameDuplicated = true;

  bool isAuthNumberNull = true;

  // 복수전공 선택 여부
  bool isDoubleMajor = false;

  final String privacyPolicy = '''
  1. 개인정보의 수집 및 이용에 대한 동의

가. 수집 및 이용 목적
- 디클(DeCl)이 제공하는 커뮤니티 서비스 이용에 필요
- 대학교 재학여부 및 본인 확인을 위하여 필요한 최소한의 범위 내에서 개인정보를 수집하고 있습니다.

나. 수집 및 이용 항목
- 필수항목 : 성명, 닉네임, 전자우편, 학과(1전공)
- 선택항목 : 학과(2전공)

다. 개인정보의 보유 및 이용 기간
- 이용자의 개인정보 수집ᆞ이용에 관한 동의일로부터 채용절차 종료 시까지 위 이용목적을 위하여 보유 및 이용하게 됩니다. 단, 서비스 종료 후에는 분쟁 해결 및 법령상 의무이행 등을 위하여 1년간 보유하게 됩니다.

라. 동의를 거부할 권리 및 동의를 거부할 경우의 불이익
- 위 개인정보 중 필수정보의 수집ᆞ이용에 관한 동의는 서비스 이용을 위해 필수적이므로, 위 사항에 동의하셔야만 서비스의 이용이 가능합니다.
- 지원자는 개인정보의 선택항목 제공 동의를 거부할 권리가 있습니다. 다만, 지원자가 선택항목 동의를 거부하는 경우 원활한 정보 확인을 할 수 없어 서비스 이용에 제한받을 수 있습니다.

2. 민감정보 수집에 대한 동의 (민감정보 기재 시에만 한함)
가. 해당 사항 없음

3. 개인정보의 제3자 제공에 대한 동의
가. 해당사항없음

디클(DeCl)이 위와 같이 개인정보를 수집ᆞ이용하는 것에 동의합니다.
  ''';

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
          const Text('닉네임'),
          const SizedBox(height: 6.0),
          SizedBox(
            width: MediaQuery.of(context).size.width,
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
          const Text('이메일'),
          const SizedBox(height: 6.0),
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
                        try {
                          final resp = await dio.post(
                            'http://$ip/api/users/authentication-code?email=$email',
                          );
                          if (resp.statusCode == 204) {
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
                        } on DioException catch (e) {
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
                        try {
                          final resp = await dio.post(
                            'http://$ip/api/users/authenticate-email?email=$email&authenticationCode=$authNumber',
                          );
                          if (resp.statusCode == 204) {
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
                        } on DioException catch (e) {
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
                      content: SingleChildScrollView(
                        child: Text(
                          privacyPolicy,
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Center(
                            child: Text('닫기'),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('내용 확인')),
        ],
      ),
    );
  }

  Widget _renderRegisterButton() {
    final dio = ref.watch(dioProvider);

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
            !isNameNull &&
            isAccept) {
          try {
            final resp = await dio.post(
              'http://$ip/api/users/register',
              data: {
                'name': name,
                'email': email,
                'nickname': nickname,
                'password': password,
                'confirmPassword': password2,
                'authenticationCode': authNumber,
                'major': major1,
                'minor': major2,
              },
            );
            if (resp.statusCode == 200) {
              showDialog(
                context: context,
                builder: (context) {
                  return NoticePopupDialog(
                    message: "회원가입이 완료되었습니다.",
                    buttonText: "닫기",
                    onPressed: () {
                      //Dialog를 닫고 로그인페이지로 나가야 하므로 두번 pop.
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
                  message: e.response?.data["message"] ?? "에러 발생",
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
              major2 = ref
                  .read(secondDepartmentListNotifierProvider.notifier)
                  .state
                  .selectedDepartment;
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
