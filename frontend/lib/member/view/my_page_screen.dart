import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/member/view/my_info_screen.dart';
import 'package:frontend/member/view/my_scrap_screen.dart';
import 'package:frontend/member/view/password_edit_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../common/component/notice_popup_dialog.dart';
import '../../common/const/colors.dart';
import '../../common/const/data.dart';
import '../../common/layout/default_layout.dart';
import '../../common/provider/dio_provider.dart';
import '../model/member_model.dart';
import '../provider/member_state_notifier_provider.dart';
import 'my_comment_screen.dart';
import 'my_post_screen.dart';

class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends ConsumerState<MyPageScreen> {
  void onMyInfoPressed(String email, String universityName, String nickname) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("내 정보"),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 32.0, right: 32.0, top: 10.0, bottom: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('이메일'),
                      const SizedBox(
                        width: 30.0,
                      ),
                      Text(email),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      const Text('학교'),
                      const SizedBox(
                        width: 42.0,
                      ),
                      Text(
                        universityName,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      const Text('닉네임'),
                      const SizedBox(
                        width: 30.0,
                      ),
                      Text(nickname),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void onAppInfoPressed() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("앱 정보"),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 32.0, right: 32.0, top: 10.0, bottom: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('앱 이름'),
                      SizedBox(
                        width: 30.0,
                      ),
                      Text('DeCl'),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      const Text('앱 버전'),
                      const SizedBox(
                        width: 30.0,
                      ),
                      Text(info.version),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void onContactPressed() async {
    //이메일은 추후 디클 전용 이메일로 변경해도 좋을듯 합니다!
    final Email email = Email(
        body: '문의할 사항을 아래에 작성해주세요.',
        subject: '[Decl 문의]',
        recipients: ['99jiasmin@gmail.com'],
        cc: [],
        bcc: [],
        attachmentPaths: [],
        isHTML: false);

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      String title = '문의하기';
      String message = '기본 메일 앱을 사용할 수 없습니다. \n이메일로 연락주세요! 99jiasmin@gmail.com';
      showNoticeAlert(title, message);
    }
  }

  void showNoticeAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            title,
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 32.0, right: 32.0, top: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Text(
                    message,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void noticeBeforeLogoutDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return NoticePopupDialog(
          message: "정말 로그아웃 하시겠습니까?",
          buttonText: "로그아웃",
          onPressed: () {
            ref.read(memberStateNotifierProvider.notifier).logout();
          },
        );
      },
    );
  }

  void noticeBeforeResignDialog() async {
    final dio = ref.watch(dioProvider);
    showDialog(
      context: context,
      builder: (context) {
        return NoticePopupDialog(
          message: "정말 탈퇴하시겠습니까?",
          buttonText: "탈퇴하기",
          onPressed: () async {
            try {
              final resp = await dio.post(
                '$ip/api/users/resign',
                options: Options(
                  headers: {
                    'accessToken': 'true',
                  },
                ),
              );
              if (resp.statusCode == 204) {
                ref.read(memberStateNotifierProvider.notifier).logout();
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

            SSEClient.unsubscribeFromSSE();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final memberState = ref.watch(memberStateNotifierProvider);

    String nickname = "";

    if (memberState is MemberModel) {
      nickname = memberState.nickname;
    }

    return DefaultLayout(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const _Top(),
              _Title(nickname: nickname),
              const SizedBox(height: 20.0),
              _buildAccountInfo(ref, context),
              const SizedBox(height: 40.0),
              _buildNoticeInfo(ref, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountInfo(WidgetRef ref, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          width: MediaQuery.of(context).size.width,
          child: const Text("계정 정보"),
        ),
        _MenuButton(
          title: "내 정보",
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const MyInfoScreen(),
              ),
            );
          },
          border: Border(
            top: BorderSide(color: Colors.grey.shade400),
            bottom: BorderSide(color: Colors.grey.shade400),
            left: const BorderSide(color: Colors.transparent),
            right: const BorderSide(color: Colors.transparent),
          ),
        ),
        _MenuButton(
          title: "내가 쓴 글",
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const MyPostScreen(),
              ),
            );
          },
        ),
        _MenuButton(
          title: "댓글단 글",
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const MyCommentScreen(),
              ),
            );
          },
        ),
        _MenuButton(
          title: "스크랩한 글",
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const MyScrapScreen(),
              ),
            );
          },
        ),
        _MenuButton(
          title: "비밀번호 변경",
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PasswordEditScreen(),
              ),
            );
          },
        ),
        _MenuButton(
          title: "회원 탈퇴하기",
          onPressed: () {
            noticeBeforeResignDialog();
          },
        ),
      ],
    );
  }

  Widget _buildNoticeInfo(WidgetRef ref, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          width: MediaQuery.of(context).size.width,
          child: const Text("이용 안내"),
        ),
        _MenuButton(
          title: "앱 정보",
          onPressed: () {
            onAppInfoPressed();
          },
          border: Border(
            top: BorderSide(color: Colors.grey.shade400),
            bottom: BorderSide(color: Colors.grey.shade400),
            left: const BorderSide(color: Colors.transparent),
            right: const BorderSide(color: Colors.transparent),
          ),
        ),
        _MenuButton(
          title: "문의하기",
          onPressed: () {
            onContactPressed();
          },
        ),
        _MenuButton(
          title: "로그아웃",
          onPressed: () {
            noticeBeforeLogoutDialog();
          },
        ),
      ],
    );
  }
}

class _Top extends StatelessWidget {
  const _Top({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: PRIMARY_COLOR,
            ),
          ),
          const Icon(
            Icons.home_outlined,
            color: PRIMARY_COLOR,
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String nickname;

  const _Title({
    required this.nickname,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '반가워요 $nickname님!',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const Text(
            '오늘도 디클에서 좋은 하루 보내세요!',
            style: TextStyle(
              fontSize: 16,
              color: BODY_TEXT_COLOR,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Border? border;

  const _MenuButton({
    required this.title,
    required this.onPressed,
    this.border,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: border ??
              Border(
                top: const BorderSide(color: Colors.transparent),
                bottom: BorderSide(color: Colors.grey.shade400),
                left: const BorderSide(color: Colors.transparent),
                right: const BorderSide(color: Colors.transparent),
              ),
        ),
        width: MediaQuery.of(context).size.width,
        height: 60.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(
                Icons.circle,
                size: 8.0,
              ),
              const SizedBox(width: 10.0),
              Text(
                title,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
