import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/component/board_card.dart';
import 'package:frontend/board/provider/board_state_notifier_provider.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/board/layout/category_circle_layout.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';

import '../../member/view/my_page_screen.dart';
import 'msg_board_add_screen.dart';

class MsgBoardListScreen extends ConsumerStatefulWidget {
  static String get routeName => 'boardList';

  const MsgBoardListScreen({
    super.key,
  });

  @override
  ConsumerState<MsgBoardListScreen> createState() => _MsgBoardListScreenState();
}

class _MsgBoardListScreenState extends ConsumerState<MsgBoardListScreen> {
  List<String> categorys = ["인기게시판", "자유게시판", "대학원게시판", "스터디모집", "질문게시판", "홍보게시판"];

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
            _renderTop(),
            _renderCategories(),
            Expanded(
              child: _renderBoardList(),
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
        child: const Icon(Icons.add),
        backgroundColor: PRIMARY_COLOR,
      ),
    );
    //test
  }

  Widget _renderTop() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          const SizedBox(width: 160.0),
          const Text(
            "DeCl",
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 80.0),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MypageScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.person,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderCategories() {
    Map<String, String> categoryCodes = {
      "인기게시판": "HOT",
      "자유게시판": "FREE",
      "대학원게시판": "GRADUATE",
      "스터디모집": "STUDY",
      "질문게시판": "QUESTION",
      "홍보게시판": "PROMOTION",
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var category in categorys)
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: CategoryCircle(
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

  Widget _renderBoardList() {
    final data = ref.watch(boardStateNotifierProvider);

    if(data is CursorPaginationModelLoading){
      return const Center(
        child: CircularProgressIndicator(
          color: PRIMARY_COLOR,
        ),
      );
    }

    if (data is CursorPaginationModelError) {
      return Center(
        child: Text("데이터를 불러올 수 없습니다."),
      );
    }

    final cp = data as CursorPaginationModel;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length + 1,
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Center(
              child: cp is CursorPaginationModelFetchingMore
                  ? CircularProgressIndicator(
                color: PRIMARY_COLOR,
              )
                  : Text(
                'Copyright 2024. Decl Team all rights reserved.\n',
                style: TextStyle(
                  color: BODY_TEXT_COLOR,
                  fontSize: 12.0,
                ),
              ),
            );
          }

          final pItem = cp.data[index];

          return GestureDetector(
            child: BoardCard.fromModel(msgBoardResponseModel: pItem),
            onTap: () async {
              print("click!!");
            },
          );
        },
        separatorBuilder: (_, index) {
          return SizedBox(height: 16.0);
        },
      ),
    );
  }
}
