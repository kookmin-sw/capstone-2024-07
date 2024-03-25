import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/comment_model.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/board/provider/comment_provider.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/layout/board_layout.dart';
import 'package:frontend/board/layout/comment_layout.dart';

class MsgBoardScreen extends StatefulWidget {
  final MsgBoardResponseModel board;
  const MsgBoardScreen({super.key, required this.board});

  @override
  State<MsgBoardScreen> createState() => _MsgBoardScreenState();
}

class _MsgBoardScreenState extends State<MsgBoardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PRIMARY_COLOR.withOpacity(0.1),
          title: Text(
            widget.board.communityTitle,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        body: Body(
          widget: widget,
        ));
  }
}

class Body extends ConsumerWidget {
  Body({
    super.key,
    required this.widget,
  });

  final MsgBoardScreen widget;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CommentModel> comments = [];
    ref
        .watch(commentStateProvider)
        .get(widget.board.id.toString())
        .then((value) => comments = value);

    ScrollController scrollController = ScrollController();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });

    return Column(
      children: [
        Board(
          board: widget.board,
          titleSize: 13,
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: comments.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Comment(
                comment: comments[index],
              );
            },
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.only(bottom: 50),
          child: Row(
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
                        // TODO : Upload comment.
                        final requestData = {
                          'postId': widget.board.id,
                          'content': textEditingController.text,
                        };
                        ref.watch(commentStateProvider).post(requestData);
                        textEditingController.clear();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
