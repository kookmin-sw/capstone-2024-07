import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/model/comment_model.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/board/provider/board_add_provider.dart';
import 'package:frontend/board/provider/comment_provider.dart';
import 'package:frontend/board/provider/comment_notifier_provider.dart';
import 'package:frontend/board/provider/reply_notifier_provider.dart';
import 'package:frontend/board/provider/reply_provider.dart';
import 'package:frontend/board/view/msg_board_add_screen.dart';
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
    await ref.watch(commentProvider).post(requestData);
    setState(() {
      isAddNewComment = true;
    });
  }

  void addNewReply(int commentId) async {
    final requestData = {
      'commentId': commentId,
      'content': textEditingController.text,
    };
    await ref.watch(commentProvider).post(requestData);
    ref.read(commentStateProvider.notifier).add(0, -1);
  }

  void modifyComment(int commentId) async {
    final requestData = {
      'content': textEditingController.text,
    };
    await ref.watch(commentProvider).modify(commentId, requestData);
    ref.read(commentStateProvider.notifier).add(1, -1);
  }

  void modifyReply(int replyId) async {
    final requestData = {
      'content': textEditingController.text,
    };
    await ref.watch(replyProvider).modify(replyId, requestData);
    ref.read(replyStateProvider.notifier).add(-1);
  }

  @override
  Widget build(BuildContext context) {
    List<int> selectCommentIndex = ref.watch(commentStateProvider);
    int selectReplyIndex = ref.watch(replyStateProvider);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: PRIMARY10_COLOR,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          shadowColor: Colors.black,
          elevation: 3,
          title: Text(
            categoryCodesReverseList[widget.board.communityTitle].toString(),
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        actionsPadding: EdgeInsets.zero,
                        backgroundColor: PRIMARY10_COLOR,
                        actions: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                      ),
                                      onPressed: () {
                                        ref
                                            .watch(boardAddProvider)
                                            .delete(widget.board.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "삭제하기",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: BODY_TEXT_COLOR.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => MsgBoardAddScreen(
                                              isEdit: true,
                                              board: widget.board,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "수정하기",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }));
              },
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
                future:
                    ref.watch(commentProvider).get(widget.board.id.toString()),
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
                        return Comment(
                          comment: comments[index],
                          selectComment:
                              selectCommentIndex == comments[index].id,
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
                            if (selectCommentIndex == -1 &&
                                selectReplyIndex == -1) {
                              // Upload comment.
                              addNewComment();
                            } else if (selectCommentIndex[0] != -1) {
                              // Upload Reply
                              addNewReply(selectCommentIndex[0]);
                            } else if (selectCommentIndex[1] != -1) {
                              // Modify Comment
                              modifyComment(selectCommentIndex[1]);
                            } else if (selectReplyIndex != -1) {
                              //Modify Reply
                              modifyReply(selectReplyIndex);
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
