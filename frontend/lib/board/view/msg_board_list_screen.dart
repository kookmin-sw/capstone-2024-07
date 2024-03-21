import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/provider/board_provider.dart';
import 'package:frontend/board/view/msg_board_add_screen.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/model/msg_board_model.dart';
import 'package:frontend/board/layout/board_layout.dart';
import 'package:frontend/board/layout/category_circle_layout.dart';
import 'package:frontend/board/provider/category_provider.dart';

import '../../member/view/my_page_screen.dart';

class MsgBoardListScreen extends StatefulWidget {
  static String get routeName => 'boardList';

  const MsgBoardListScreen({
    super.key,
  });

  @override
  State<MsgBoardListScreen> createState() => _MsgBoardListScreenState();
}

class _MsgBoardListScreenState extends State<MsgBoardListScreen> {
  // late Future<List<MsgBoardListModel>> boards;
  List<String> categorys = categorysList;

  @override
  void initState() {
    super.initState();
    // TODO: add board = http
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _renderTop(),
            SizedBox(
              height: MediaQuery.of(context).size.height - 111,
              child: BoardListWidget(
                categorys: categorys,
              ),
            ),
          ],
        ),
      ),
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(
      //       horizontal: 50,
      //       vertical: 50,
      //     ),
      //     child: FutureBuilder(
      //       future: boards,
      //       builder: (context, snapshot) {
      //         if (snapshot.hasData) {
      //           return const Column(
      //             children: [
      //               // TODO : Future
      //               // for(var board in snapshot.data!)
      //               //   board.category
      //             ],
      //           );
      //         }
      //         return const Center(child: Text("..."));
      //       },
      //     ),
      //   ),
      // ),
    );
    //test
  }

  Widget _renderTop() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      height: 30.0,
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
            icon: const Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}

class BoardListWidget extends ConsumerWidget {
  const BoardListWidget({
    super.key,
    required this.categorys,
  });

  final List<String> categorys;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clickedBoardList = ref.watch(categoryStateProvider);
    List<MsgBoardModel> msgboardlistinstance = ref.watch(boardStateProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 35,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var category in categorys)
                Padding(
                  padding: const EdgeInsets.all(7),
                  child: CategoryCircle(
                    category: category,
                    type: true,
                  ),
                )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: BODY_TEXT_COLOR.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              for (var board in msgboardlistinstance)
                if (clickedBoardList.isEmpty)
                  Board(
                    board: board,
                    canTap: true,
                    titleSize: 11,
                  )
                else if (clickedBoardList.contains(board.category))
                  Board(
                    board: board,
                    canTap: true,
                    titleSize: 11,
                  ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(50),
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MsgBoardAddScreen(
                    isEdit: false,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
