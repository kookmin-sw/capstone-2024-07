import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/board/component/board_card.dart';
import 'package:frontend/board/provider/board_state_notifier_provider.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/view/msg_board_add_screen.dart';
import 'package:frontend/board/view/msg_board_screen.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';
import 'package:frontend/common/provider/dio_provider.dart';

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
  // late Future<List<MsgBoardListModel>> boards;
  List<String> categorys = categorysList;
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    if (controller.offset > controller.position.maxScrollExtent - 150) {
      ref.read(boardStateNotifierProvider.notifier).paginate(
            fetchMore: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const MsgBoardAddScreen(
                isEdit: false,
              ),
            ),
          );
        },
        backgroundColor: PRIMARY50_COLOR,
        child: const Icon(Icons.add),
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
    if(activatedMajor == major){
      majors.add(major);
      if(minor.isNotEmpty) majors.add(minor);
    } else{
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
                  'http://$ip/api/belongs/switch-departments',
                  options: Options(
                    headers: {
                      'accessToken': 'true',
                    },
                  ),
                );
                if (resp.statusCode == 200) {
                  // 다시 paginate api 요청을 보낸다.
                  ref.read(memberStateNotifierProvider.notifier).getMe();
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          renderMajorSelectBox(),
          const Text(
            "DeCl",
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 1.0),
          SizedBox(
            width: 70,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MypageScreen(),
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
    );
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
                  categoryCode: categoryCodes[category]!,
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

    return ListView.separated(
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
    );
  }
}
