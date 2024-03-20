import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/component/board_card.dart';
import 'package:frontend/board/provider/board_state_notifier_provider.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/board/layout/category_circle_layout.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';

import '../../member/view/my_page_screen.dart';

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
  List<MsgBoardResponseModel> msgboardlistinstance = [];
  List<String> categorys = [];

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
          print("floating button clicked!!!");
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
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var category in categorys)
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: CategoryCircle(
                category: category,
                type: true,
              ),
            )
        ],
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
