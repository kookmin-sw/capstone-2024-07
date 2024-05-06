import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/board/component/board_card.dart';
import 'package:frontend/board/model/msg_board_detail_response_model.dart';
import 'package:frontend/board/provider/board_add_provider.dart';
import 'package:frontend/board/provider/board_detail_state_notifier_provider.dart';
import 'package:frontend/board/provider/board_state_notifier_provider.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/provider/comment_pagination_provider.dart';
import 'package:frontend/board/provider/payload_state_notifier_provider.dart';
import 'package:frontend/board/view/msg_board_add_screen.dart';
import 'package:frontend/board/view/msg_board_screen.dart';
import 'package:frontend/board/view/search_screen.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:frontend/member/provider/mypage/my_comment_state_notifier_provider.dart';

import '../../common/component/notice_popup_dialog.dart';
import '../../common/const/data.dart';
import '../../member/model/member_model.dart';
import '../../member/provider/member_state_notifier_provider.dart';
import '../../member/view/my_page_screen.dart';
import '../component/category_circle_with_provider.dart';

class MsgBoardListScreen extends ConsumerStatefulWidget {
  static String get routeName => 'boardList';

  const MsgBoardListScreen({
    super.key,
  });

  @override
  ConsumerState<MsgBoardListScreen> createState() => _MsgBoardListScreenState();
}

class _MsgBoardListScreenState extends ConsumerState<MsgBoardListScreen> {
  List<String> categorys = categorysList;
  final ScrollController controller = ScrollController();
  String payload = "";

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    if (controller.offset > controller.position.maxScrollExtent - 150) {
      ref.read(boardStateNotifierProvider.notifier).paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    payload = ref.watch(payloadNotifier);
    if (payload != "") {
      debugPrint("Show Payload Page : $payload");
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await ref.read(payloadNotifier.notifier).add("");
        ref.read(boardDetailNotifier.notifier).add(int.parse(payload));
        MsgBoardDetailResponseModel resp;
        ref
            .read(commentPaginationProvider.notifier)
            .paginate(forceRefetch: true);
        ref.read(myCommentStateNotifierProvider.notifier).lastId =
            9223372036854775807;
        ref
            .read(myCommentStateNotifierProvider.notifier)
            .paginate(forceRefetch: true);
        ref.watch(boardAddProvider).get(int.parse(payload)).then((value) {
          resp = value;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MsgBoardScreen(
                      board: resp,
                    ),
                fullscreenDialog: true),
          );
        });
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            renderTop(),
            renderCategories(),
            Expanded(
              child: renderBoardList(),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: 10,
            bottom: 100,
            child: FloatingActionButton(
              heroTag: 'searchButton',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SearchScreen(),
                  ),
                );
              },
              shape: const CircleBorder(),
              backgroundColor: Colors.blue[300],
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 30,
            child: FloatingActionButton(
              heroTag: 'addButton',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MsgBoardAddScreen(
                      isEdit: false,
                      board: MsgBoardResponseModel(
                        id: 0,
                        userId: 0,
                        userNickname: "",
                        universityName: "",
                        communityId: 0,
                        communityTitle: "",
                        postTitle: "",
                        postContent: "",
                        images: [],
                        count: ReactCountModel(
                            commentReplyCount: 0, likeCount: 0, scrapCount: 0),
                        isQuestion: false,
                        isBlockedUser: false,
                        createdDateTime: "",
                        imageCount: 0,
                      ),
                    ),
                  ),
                );
              },
              shape: const CircleBorder(),
              backgroundColor: PRIMARY50_COLOR,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
    //test
  }

  Widget renderMajorSelectBox() {
    final memberState = ref.watch(memberStateNotifierProvider);

    String major = "";
    String minor = "";
    String activatedMajor = "";

    if (memberState is MemberModel) {
      major = memberState.major;
      minor = memberState.minor;
      activatedMajor = memberState.activatedDepartment;
    }

    List<String> majors = [];
    if (activatedMajor == major) {
      majors.add(major);
      if (minor.isNotEmpty) majors.add(minor);
    } else {
      majors = [minor, major];
    }

    final dio = ref.watch(dioProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: activatedMajor,
          onChanged: (String? newValue) async {
            if (newValue != null && activatedMajor != newValue) {
              try {
                // 활성화된 전공을 변경하는 API 요청을 보낸다.
                final resp = await dio.put(
                  '$ip/api/belongs/switch-departments',
                  options: Options(
                    headers: {
                      'accessToken': 'true',
                    },
                  ),
                );
                if (resp.statusCode == 200) {
                  // 다시 paginate api 요청을 보낸다.
                  ref.read(memberStateNotifierProvider.notifier).getMe();
                  ref.read(boardStateNotifierProvider.notifier).lastId =
                      9223372036854775807;
                  ref
                      .read(boardStateNotifierProvider.notifier)
                      .paginate(forceRefetch: true);
                }
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return NoticePopupDialog(
                      message: "오류발생",
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
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          items: majors.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.fade,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget renderTop() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
        height: 50.0,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  ref.read(boardStateNotifierProvider.notifier).lastId =
                      9223372036854775807;
                  ref
                      .read(boardStateNotifierProvider.notifier)
                      .paginate(forceRefetch: true);
                },
                child: Image.asset(
                  'asset/imgs/logo.png',
                  width: 60.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                renderMajorSelectBox(),
                SizedBox(
                  width: 70,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MyPageScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.person,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget renderCategories() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5),
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var category in categorys)
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: CategoryCircleWithProvider(
                  category: category,
                  categoryCode: categoryCodesList[category]!,
                  type: true,
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget renderBoardList() {
    final data = ref.watch(boardStateNotifierProvider);

    if (data is CursorPaginationModelLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: PRIMARY_COLOR,
        ),
      );
    }

    if (data is CursorPaginationModelError) {
      return const Center(
        child: Text("데이터를 불러올 수 없습니다."),
      );
    }

    final cp = data as CursorPaginationModel;
    for (int i = 0; i < cp.data.length; i++) {
      if (cp.data[i].isBlockedUser) {
        cp.data.removeAt(i);
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(boardStateNotifierProvider.notifier).lastId =
            9223372036854775807;
        await ref
            .read(boardStateNotifierProvider.notifier)
            .paginate(forceRefetch: true);
      },
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length + 1,
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Center(
              child: cp is CursorPaginationModelFetchingMore
                  ? const CircularProgressIndicator(
                      color: PRIMARY_COLOR,
                    )
                  : const Text(
                      'Copyright 2024. Decl Team all rights reserved.\n',
                      style: TextStyle(
                        color: BODY_TEXT_COLOR,
                        fontSize: 12.0,
                      ),
                    ),
            );
          }

          final MsgBoardResponseModel pItem = cp.data[index];

          return GestureDetector(
            child: BoardCard.fromModel(msgBoardResponseModel: pItem),
            onTap: () async {
              // 상세페이지
              ref.read(boardDetailNotifier.notifier).add(pItem.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MsgBoardScreen(
                          board: pItem,
                        ),
                    fullscreenDialog: true),
              );
            },
          );
        },
        separatorBuilder: (_, index) {
          return const SizedBox(height: 1.0);
        },
      ),
    );
  }
}
