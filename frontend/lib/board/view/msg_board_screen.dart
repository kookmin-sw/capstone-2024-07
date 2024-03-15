import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/comment_model.dart';
import 'package:frontend/board/model/msg_board_model.dart';
import 'package:frontend/board/provider/comment_provider.dart';
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
      widget.board.postId,
      "1",
      "익명1",
      "ㅇㅈ",
      "0",
    ));
    commentlistinstance.add(CommentModel(
      "2",
      widget.board.postId,
      "2",
      "익명2",
      "ㅇㅈㅇㅈ",
      "0",
    ));
    commentlistinstance.add(CommentModel(
      "3",
      widget.board.postId,
      "3",
      "익명3",
      "ㅆㅇㅈ",
      "0",
    ));
    commentlistinstance.add(CommentModel(
      "4",
      widget.board.postId,
      "4",
      "익명4",
      "ㅆㅆㅇㅈ",
      "0",
    ));
    commentlistinstance.add(CommentModel(
      "5",
      widget.board.postId,
      "5",
      "익명5",
      "ㅆㅆㅆㅇㅈ",
      "0",
    ));
  }

  @override
  Widget build(BuildContext context) {
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
        body: Body(widget: widget, commentlistinstance: commentlistinstance));
  }
}

class Body extends ConsumerWidget {
  const Body({
    super.key,
    required this.widget,
    required this.commentlistinstance,
  });

  final MsgBoardScreen widget;
  final List<CommentModel> commentlistinstance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CommentModel> temp = ref.watch(commentStateProvider);
    if (temp.isNotEmpty) {
      commentlistinstance.add(temp.last);
    }
    return Column(
      children: [
        Board(
          board: widget.board,
          canTap: false,
          titleSize: 13,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: commentlistinstance.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Comment(
                comment: commentlistinstance[index],
              );
            },
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.only(bottom: 50),
          child: Row(
            children: [
              UploadComment(
                postId: widget.board.postId,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UploadComment extends ConsumerWidget {
  final String postId;
  final TextEditingController textEditingController = TextEditingController();

  UploadComment({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: '입력',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              // TODO : Upload comment.
              ref.read(commentStateProvider.notifier).add(
                    CommentModel(
                      "5",
                      postId,
                      "4",
                      "익명4",
                      textEditingController.text,
                      "0",
                    ),
                  );
              textEditingController.clear();
            },
          ),
        ),
      ),
    );
  }
}
