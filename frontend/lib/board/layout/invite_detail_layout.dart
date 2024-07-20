import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

class InviteDetailLayout extends ConsumerWidget {
  const InviteDetailLayout({super.key});

  void notAllowed(BuildContext context, String s) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    s,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: PRIMARY50_COLOR,
                    ),
                    child: const Text(
                      "확인",
                      style: TextStyle(
                        fontSize: 13,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PRIMARY10_COLOR,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        shadowColor: Colors.black,
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "친구 초대 이벤트",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: height,
          ),
          Image.asset(
            'asset/imgs/invite_image01.png',
            width: width,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 50.0, top: 140.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\"컴퓨터공학과\"",
                      style: TextStyle(
                        fontSize: 20,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "친구들을 초대해주세요!",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: BODY_TEXT_COLOR,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 4.0,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "이벤트 참여방법",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "•  친구에게 알리기 버튼 클릭",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        const Text(
                          "•  카카오톡이나 메시지 등으로 친구들에게\n           앱 다운로드 링크 보내기",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0.0, -14.0),
                          child: Image.asset(
                            'asset/imgs/logo.png',
                            height: 10.0,
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        const Row(
                          children: [
                            Text(
                              "•  친구가 회원가입을 할 때, ",
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "\"추천 아이디\"",
                              softWrap: true,
                              style: TextStyle(
                                color: PRIMARY_COLOR,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "에",
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "내 아이디 적어주기",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () async {
                  bool isKakaoTalkSharingAvailable =
                      await ShareClient.instance.isKakaoTalkSharingAvailable();
                  if (isKakaoTalkSharingAvailable) {
                    final FeedTemplate defaultFeed = FeedTemplate(
                      content: Content(
                        title: "Decl(디클)",
                        description: "대학교 학과별 커뮤니티",
                        imageUrl: Uri.parse(
                            'https://private-user-images.githubusercontent.com/67682840/324183234-a6255c3f-ff7a-43b7-8e14-7e1199be3ac0.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MjA5NTE3NzAsIm5iZiI6MTcyMDk1MTQ3MCwicGF0aCI6Ii82NzY4Mjg0MC8zMjQxODMyMzQtYTYyNTVjM2YtZmY3YS00M2I3LThlMTQtN2UxMTk5YmUzYWMwLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDA3MTQlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwNzE0VDEwMDQzMFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWE4ZWFlNjVkODc5NTYyODIzZDFjYjBhNWYxZjVmNDE2OTdmZGZlMDNjYWVhNWUxMzI0M2U2MjRhOTc2ZDc3YjUmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.Z8rbxgp2ii9wIIM418ku47W64_mp1oFJGgMDZKnmr78'),
                        link: Link(
                          androidExecutionParams: {
                            'key1': 'value1',
                            'key2': 'value2'
                          },
                          iosExecutionParams: {
                            'key1': 'value1',
                            'key2': 'value2'
                          },
                        ),
                      ),
                      buttons: [
                        Button(
                          title: "앱 다운로드 받기",
                          link: Link(
                            androidExecutionParams: {
                              'key1': 'value1',
                              'key2': 'value2'
                            },
                            iosExecutionParams: {
                              'key1': 'value1',
                              'key2': 'value2'
                            },
                          ),
                        ),
                      ],
                    );

                    try {
                      Uri uri = await ShareClient.instance
                          .shareDefault(template: defaultFeed);
                      await ShareClient.instance.launchKakaoTalk(uri);
                    } catch (error) {
                      debugPrint("KakaoTalk Error : $error");
                    }
                  } else {
                    debugPrint("KakaoTalk not Installed.");
                    Clipboard.setData(const ClipboardData(
                        text:
                            "Decl(디클)\n대학교 학과별 커뮤니티\n\nIOS\nhttps://apps.apple.com/kr/app/%EB%94%94%ED%81%B4/id6499332881\n\nANDROID\nhttps://play.google.com/store/apps/details?id=com.capstone.decl&pcampaignid=web_share"));
                    notAllowed(context, "링크가 복사되었습니다.");
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: ACTIVE_COLOR,
                      ),
                      child: const Center(
                        child: Text(
                          "친구에게 알리기",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 3,
            child: Image.asset(
              'asset/imgs/invite_image02.png',
              width: width / 2,
            ),
          ),
        ],
      ),
    );
  }
}
