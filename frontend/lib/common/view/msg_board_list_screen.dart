import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/common/const/msg_board_model.dart';
import 'package:frontend/common/layout/board_layout.dart';
import 'package:frontend/common/layout/category_circle_layout.dart';
import 'package:frontend/common/provider/board_provider.dart';

class MsgBoardListScreen extends StatefulWidget {
  final String category;
  const MsgBoardListScreen({
    super.key,
    required this.category,
  });

  @override
  State<MsgBoardListScreen> createState() => _MsgBoardListScreenState();
}

class _MsgBoardListScreenState extends State<MsgBoardListScreen> {
  // late Future<List<MsgBoardListModel>> boards;
  List<MsgBoardModel> msgboardlistinstance = [];
  List<String> categorys = [];

  @override
  void initState() {
    super.initState();
    // TODO: add board = http
    categorys.add("인기게시판");
    categorys.add("자유게시판");
    categorys.add("전공게시판");
    categorys.add("취업");
    categorys.add("대학원");
    categorys.add("기타");
    categorys.add("공모전 공고");

    msgboardlistinstance.add(MsgBoardModel(
      "1",
      "인기게시판",
      "종강마렵다",
      "ㅈㄱㄴssssssssssssssssssssssssssssssssssssssssssssssssssddddddddddddpppppabcdefg",
      "20",
      "3",
      "0",
      "24/03/04 13:45",
      "익명",
    ));
    msgboardlistinstance.add(MsgBoardModel(
      "2",
      "인기게시판",
      "종강종강",
      "종강종강종강종강",
      "15",
      "2",
      "0",
      "24/03/04 14:45",
      "익명",
    ));
    msgboardlistinstance.add(MsgBoardModel(
      "3",
      "인기게시판",
      "토끼는 깡종강종강",
      "거북이도 종강종강",
      "10",
      "4",
      "0",
      "24/03/04 15:45",
      "익명",
    ));
    msgboardlistinstance.add(MsgBoardModel(
      "4",
      "인기게시판",
      "교수님 정강이 때릴 사람 구합니다.",
      "아이고 종강이야",
      "5",
      "3",
      "0",
      "24/03/04 16:45",
      "익명",
    ));
    msgboardlistinstance.add(MsgBoardModel(
      "5",
      "인기게시판",
      "슬슬 종강할 때 되지 않았나",
      "눈치껏 종강하자",
      "6",
      "2",
      "0",
      "24/03/04 17:45",
      "익명",
    ));
    msgboardlistinstance.add(MsgBoardModel(
      "6",
      "인기게시판",
      "그냥 종강좀 해라",
      "이만큼 했음 됬지 않늬",
      "3",
      "1",
      "0",
      "24/03/04 18:45",
      "익명",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 3,
        title: const Text(
          "Decl",
          style: TextStyle(
            fontSize: 30,
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: BoardListWidget(
          categorys: categorys, msgboardlistinstance: msgboardlistinstance),
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
  }
}

class BoardListWidget extends ConsumerWidget {
  const BoardListWidget({
    super.key,
    required this.categorys,
    required this.msgboardlistinstance,
  });

  final List<String> categorys;
  final List<MsgBoardModel> msgboardlistinstance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clickedBoardList = ref.watch(boardStateProvider);
    return Column(
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
      ],
    );
  }
}
