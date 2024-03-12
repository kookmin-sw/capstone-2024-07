import 'package:flutter/material.dart';
import 'package:frontend/board/model/comment_model.dart';
import 'package:frontend/board/model/msg_board_model.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/layout/board_layout.dart';
import 'package:frontend/board/layout/comment_layout.dart';

class MsgBoardScreen extends StatefulWidget {
  final MsgBoardModel board;
  const MsgBoardScreen({super.key, required this.board});

  @override
  State<MsgBoardScreen> createState() => _MsgBoardScreenState();
}

class _MsgBoardScreenState extends State<MsgBoardScreen> {
  List<CommentModel> commentlistinstance = [];

  @override
  void initState() {
    super.initState();
    commentlistinstance.add(CommentModel(
      "1",
      "익명1",
      "ㅇㅈ",
      "0",
    ));
    commentlistinstance.add(CommentModel(
      "2",
      "익명2",
      "ㅇㅈㅇㅈ",
      "0",
    ));
    commentlistinstance.add(CommentModel(
      "3",
      "익명3",
      "ㅆㅇㅈ",
      "0",
    ));
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR.withOpacity(0.1),
        title: Text(
          widget.board.category,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Board(
                  board: widget.board,
                  canTap: false,
                  titleSize: 13,
                ),
                for (var comment in commentlistinstance)
                  Comment(
                    comment: comment,
                  ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: '입력',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: BODY_TEXT_COLOR.withOpacity(0.5),
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        child: Icon(
                          Icons.send,
                          color: PRIMARY_COLOR.withOpacity(0.5),
                          size: 30,
                        ),
                        onTap: () {
                          textEditingController.clear();
                          // TODO : Upload comment.
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
