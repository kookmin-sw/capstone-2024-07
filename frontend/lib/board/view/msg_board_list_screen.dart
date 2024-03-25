import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/board/component/board_card.dart';
import 'package:frontend/board/provider/board_state_notifier_provider.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/view/msg_board_add_screen.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';

import '../../common/const/data.dart';
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
        backgroundColor: PRIMARY_COLOR,
        child: const Icon(Icons.add),
      ),
    );
    //test
  }

  Widget renderTop() {
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
                  builder: (_) => const MypageScreen(),
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

  Widget renderCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var category in categorys)
              Padding(
                padding: const EdgeInsets.all(6.0),
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

        final pItem = cp.data[index];

        return GestureDetector(
          child: BoardCard.fromModel(msgBoardResponseModel: pItem),
          onTap: () async {
            // 상세페이지
            print("click!!");
          },
        );
      },
      separatorBuilder: (_, index) {
        return const SizedBox(height: 16.0);
      },
    );
  }
}
