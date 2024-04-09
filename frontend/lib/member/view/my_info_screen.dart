import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/common/provider/dio_provider.dart';

import '../../common/component/notice_popup_dialog.dart';
import '../../common/const/data.dart';
import '../model/member_model.dart';
import '../provider/first_major_state_notifier_provider.dart';
import '../provider/member_state_notifier_provider.dart';
import '../provider/second_major_state_notifier_provider.dart';

class MyInfoScreen extends ConsumerStatefulWidget {
  const MyInfoScreen({super.key});

  @override
  ConsumerState<MyInfoScreen> createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends ConsumerState<MyInfoScreen> {
  bool isWillingToChangeMajor = false;
  String selectedMajor = "";
  String selectedMinor = "";

  @override
  Widget build(BuildContext context) {
    final dio = ref.watch(dioProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _renderTop(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 10.0),
                child: Column(
                  children: [
                    _renderMyInfo(),
                    if (!isWillingToChangeMajor)
                      _renderButton(
                        "전공 변경하기",
                        () async {
                          try {
                            final resp = await dio.get(
                              'http://$ip/api/belongs/remain',
                              options: Options(
                                headers: {
                                  'accessToken': 'true',
                                },
                              ),
                            );
                            if (resp.statusCode == 200) {
                              int remainDays = resp.data['remainDays'];
                              int remainHours = resp.data['remainHours'];
                              int remainMinutes = resp.data['remainMinutes'];
                              print('$remainDays/$remainHours/$remainMinutes');

                              if(remainDays==0 && remainHours==0 && remainMinutes==0){
                                setState(() {
                                  isWillingToChangeMajor = true;
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return NoticePopupDialog(
                                      message: "$remainDays일 $remainHours시간 $remainMinutes분 뒤에 변경이 가능합니다.",
                                      buttonText: "닫기",
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                              }
                            }
                          } on DioException catch (e){
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
                          } catch (e){
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
                        },
                      ),
                    if (isWillingToChangeMajor) _renderChangeMajorField(),
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
          _renderSimpleTextBox('닉네임', nickname),
          _renderSimpleTextBox('학교', universityName),
          _renderSimpleTextBox('이메일', email),
          _renderSimpleTextBox('전공', major),
          _renderSimpleTextBox('부전공', minor),
        ],
      ),
    );
  }

  Widget _renderSimpleTextBox(String fieldName, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            fieldName,
          ),
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
      padding: const EdgeInsets.only(top: 12.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
          minimumSize: Size(
            MediaQuery.of(context).size.width,
            40.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onButtonClicked,
        child: Text(text),
      ),
    );
  }

  Widget _renderChangeMajorField() {
    final dio = ref.watch(dioProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: Column(
        children: [
          _renderFirstMajorField(),
          _renderSecondMajorField(),
          _renderButton(
            "학과 변경하기",
            () async {
              try {
                final resp = await dio.put(
                  'http://$ip/api/belongs/change-departments',
                  options: Options(
                    headers: {
                      'accessToken': 'true',
                    },
                  ),
                  data: {
                    'major': selectedMajor,
                    'minor': selectedMinor,
                  },
                );
                if (resp.statusCode == 204) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return NoticePopupDialog(
                        message: "학과 변경이 완료되었습니다.",
                        buttonText: "닫기",
                        onPressed: () {
                          Navigator.pop(context);
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
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              } catch (e){
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
            },
          ),
          _renderButton(
            "취소",
                () {
              setState(() {
                isWillingToChangeMajor = false;
              });
            },
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
            style: TextStyle(
              color: BODY_TEXT_COLOR,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 240,
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
                              selectedMajor = selectedDepartment;
                            });
                          }
                        });
                      }
                    },
                  ),
                ),
                Container(
                  width: 240,
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
                            selectedMajor = selectedDepartment;
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
            style: TextStyle(
              color: BODY_TEXT_COLOR,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 240,
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
                              selectedMinor = selectedDepartment;
                            });
                          }
                        });
                      }
                    },
                  ),
                ),
                Container(
                  width: 240,
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
                            selectedMinor = selectedDepartment;
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
}
