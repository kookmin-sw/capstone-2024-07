import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/comment_model.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/board/provider/comment_provider.dart';
import 'package:frontend/board/provider/reply_notifier_provider.dart';
import 'package:frontend/board/provider/reply_provider.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/layout/board_layout.dart';
import 'package:frontend/board/layout/comment_layout.dart';

class MsgBoardScreen extends ConsumerStatefulWidget {
  final MsgBoardResponseModel board;
  const MsgBoardScreen({super.key, required this.board});

  @override
  ConsumerState<MsgBoardScreen> createState() => _MsgBoardScreenState();
}

class _MsgBoardScreenState extends ConsumerState<MsgBoardScreen> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isAddNewComment = false;

  void addNewComment() async {
    final requestData = {
      'postId': widget.board.id.toInt(),
      'content': textEditingController.text,
    };
    await ref.watch(commentStateProvider).post(requestData);
    setState(() {
      isAddNewComment = true;
    });
  }

  void addNewReply(int commentId) async {
    final requestData = {
      'commentId': commentId,
      'content': textEditingController.text,
    };
    await ref.watch(replyProvider).post(requestData);
    ref.read(replyStateProvider.notifier).add(-1);
  }

  @override
  Widget build(BuildContext context) {
    int selectIndex = ref.watch(replyStateProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PRIMARY10_COLOR,
          title: Text(
            widget.board.communityTitle,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
        body: Column(
          children: [
            Board(
              board: widget.board,
              titleSize: 13,
            ),
            Expanded(
              child: FutureBuilder(
                future: ref
                    .watch(commentStateProvider)
                    .get(widget.board.id.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<CommentModel> comments = snapshot.data ?? [];
                    ScrollController scrollController = ScrollController();
                    if (isAddNewComment) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        scrollController
                            .jumpTo(scrollController.position.maxScrollExtent);
                      });
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: comments.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        print("$selectIndex ${comments[index].id}");
                        return Comment(
                          comment: comments[index],
                          selectComment: selectIndex == comments[index].id,
                        );
                      },
                    );
                  }
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
                          child: const Icon(
                            Icons.send,
                            color: PRIMARY50_COLOR,
                            size: 30,
                          ),
                          onTap: () {
                            if (selectIndex == -1) {
                              // Upload comment.
                              addNewComment();
                            } else {
                              addNewReply(selectIndex);
                            }
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
        ));
  }
}
