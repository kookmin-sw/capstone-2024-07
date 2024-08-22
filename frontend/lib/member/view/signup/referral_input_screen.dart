import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:frontend/common/const/data.dart';

import '../../../common/component/notice_popup_dialog.dart';
import '../../../common/provider/dio_provider.dart';
import '../login_screen.dart';

class ReferralInputScreen extends ConsumerStatefulWidget {
  @override
  _ReferralInputScreenState createState() => _ReferralInputScreenState();
}

class _ReferralInputScreenState extends ConsumerState<ReferralInputScreen> {
  bool isNoneChecked = false;
  String referralId = '';

  void submitReferral() async {
    if (!isNoneChecked && referralId.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return NoticePopupDialog(
            message: "추천인 아이디를 입력하거나 '없음'을 체크해주세요.",
            buttonText: "닫기",
            onPressed: () {
              Navigator.pop(context);
            },
          );
        },
      );
      return;
    }

    if (isNoneChecked) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      return;
    }

    final dio = ref.read(dioProvider);

    try {
      final response = await dio.post(
        '$ip/api/recommend',
        data: {'userName': referralId},
      );
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
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
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return NoticePopupDialog(
            message: "알 수 없는 에러가 발생했습니다.",
            buttonText: "닫기",
            onPressed: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '추천인 아이디를 입력해 주세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: '추천인 아이디를 입력해 주세요.',
                hintStyle: TextStyle(fontWeight: FontWeight.w400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  referralId = value;
                });
              },
              enabled: !isNoneChecked,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isNoneChecked,
                  onChanged: (value) {
                    setState(() {
                      isNoneChecked = value ?? false;
                      if (isNoneChecked) {
                        referralId = '';
                      }
                    });
                  },
                ),
                Text('없음'),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: submitReferral,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAA71D8),
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '확인',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
