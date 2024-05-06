import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/model/comment_model.dart';
import 'package:frontend/board/model/exception_model.dart';
import 'package:frontend/board/model/msg_board_detail_response_model.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/board/provider/block_provider.dart';
import 'package:frontend/board/provider/board_add_provider.dart';
import 'package:frontend/board/provider/board_state_notifier_provider.dart';
import 'package:frontend/board/provider/comment_pagination_provider.dart';
import 'package:frontend/board/provider/comment_provider.dart';
import 'package:frontend/board/provider/comment_notifier_provider.dart';
import 'package:frontend/board/provider/image_provider.dart';
import 'package:frontend/board/provider/network_image_provider.dart';
import 'package:frontend/board/provider/reply_notifier_provider.dart';
import 'package:frontend/board/provider/reply_provider.dart';
import 'package:frontend/board/provider/report_provider.dart';
import 'package:frontend/board/view/msg_board_add_screen.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/layout/board_layout.dart';
import 'package:frontend/board/layout/comment_layout.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';
import 'package:frontend/member/model/member_model.dart';
import 'package:frontend/member/provider/member_state_notifier_provider.dart';
import 'package:frontend/member/provider/mypage/my_comment_state_notifier_provider.dart';
import 'package:frontend/member/provider/mypage/my_post_state_notifier_provider.dart';

import '../../common/const/ip_list.dart';

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
    controller.addListener(scrollListener);
  }

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController controller = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool firstTime = true;

  void scrollListener() {
    if (controller.offset > controller.position.maxScrollExtent - 150) {
      ref.read(commentPaginationProvider.notifier).paginate(
            fetchMore: true,
          );
    }
  }

  void refresh() {
    ref.read(commentPaginationProvider.notifier).paginate(forceRefetch: true);
    ref.read(myCommentStateNotifierProvider.notifier).lastId =
        9223372036854775807;
    ref
        .read(myCommentStateNotifierProvider.notifier)
        .paginate(forceRefetch: true);

    firstTime = true;
  }

  void addNewComment() async {
    final requestData = {
      'postId': widget.board.id.toInt(),
      'content': textEditingController.text,
    };
    try {
      await ref.watch(commentProvider).post(requestData);
      refresh();
    } on DioException catch (e) {
      if (e.response != null) {
        ExceptionModel exc = e.response!.data;
        notAllowed(exc.message);
      }
    }
  }

  void addNewReply(int commentId) async {
    final requestData = {
      'commentId': commentId,
      'content': textEditingController.text,
    };

    try {
      await ref.watch(replyProvider).post(requestData);
    } on DioException catch (e) {
      if (e.response != null) {
        ExceptionModel exc = e.response!.data;
        notAllowed(exc.message);
      }
    }

    await ref.read(commentStateProvider.notifier).add(0, -1);
    refresh();
  }

  void modifyComment(int commentId) async {
    final requestData = {
      'content': textEditingController.text,
    };
    await ref.watch(commentProvider).modify(commentId, requestData);
    await ref.read(commentStateProvider.notifier).add(1, -1);
    refresh();
  }

  void modifyReply(int replyId) async {
    final requestData = {
      'content': textEditingController.text,
    };
    await ref.watch(replyProvider).modify(replyId, requestData);
    await ref.read(replyStateProvider.notifier).add(1, -1);
    refresh();
  }

  void deleteComment(int commentId) async {
    await ref.watch(commentProvider).delete(commentId);
    ref.read(commentStateProvider.notifier).add(2, -1);
    refresh();
  }

  void deleteReply(int replyId) async {
    await ref.watch(replyProvider).delete(replyId);
    ref.read(replyStateProvider.notifier).add(2, -1);
    refresh();
  }

  void sendReport(String reason) async {
    final data = {
      'reportedObjectId': widget.board.id,
      'reportType': "POST",
      'reason': reason,
    };
    await ref.read(reportProvider).post(data);
    notAllowed("신고되었습니다.");
  }

  void selectReportReason() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.zero,
            backgroundColor: PRIMARY10_COLOR,
            content: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    "신고 사유를 선택해주세요.",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
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
                            Navigator.of(context).pop();
                            sendReport('INSULTING');
                          },
                          child: const Text(
                            "욕설/비하",
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
                            sendReport('COMMERCIAL');
                          },
                          child: const Text(
                            "상업적 광고 및 판매",
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
                            sendReport('INAPPROPRIATE');
                          },
                          child: const Text(
                            "게시판 성격에 부적절함",
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
                            sendReport('FRAUD');
                          },
                          child: const Text(
                            "유출/사칭/사기",
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
                            sendReport('SPAM');
                          },
                          child: const Text(
                            "낚시/놀람/도배",
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
                            sendReport('PORNOGRAPHIC');
                          },
                          child: const Text(
                            "음란물/불건전한 만남 및 대화",
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
  }

  void boardMore(bool isMine) {
    try {
      if (isMine) {
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
                              onPressed: () async {
                                await ref
                                    .watch(boardAddProvider)
                                    .delete(widget.board.id);
                                await ref
                                    .read(boardStateNotifierProvider.notifier)
                                    .paginate(forceRefetch: true);
                                await ref
                                    .read(myPostStateNotifierProvider.notifier)
                                    .paginate(forceRefetch: true);
                                Navigator.of(context).pop();
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
      } else {
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
                                // TODO : Report Board
                                Navigator.of(context).pop();
                                selectReportReason();
                              },
                              child: const Text(
                                "신고하기",
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
                                ref
                                    .read(blockProvider)
                                    .post(widget.board.userId);
                              },
                              child: const Text(
                                "차단하기",
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
      }
    } catch (e) {
      debugPrint("myModel 불러오는 문제 발생 : $e");
    }
  }

  void notification() {
    // TODO : notification on/off
  }

  void notAllowed(String s) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    s,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: PRIMARY50_COLOR,
                    ),
                    child: const Text(
                      "확인",
                      style: TextStyle(fontSize: 13, color: PRIMARY_COLOR),
                    ),
                  ),
                ],
              ),
            ],
          );
        }));
  }

  void filterDialog(String s, List<int> selectCommentIndex,
      List<int> selectReplyIndex) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    s,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();

                      if (selectCommentIndex[0] != -1) {
                        // Upload Reply
                        addNewReply(selectCommentIndex[0]);
                      } else if (selectCommentIndex[1] != -1) {
                        // Modify Comment
                        modifyComment(selectCommentIndex[1]);
                      } else if (selectReplyIndex[1] != -1) {
                        // Modify Reply
                        modifyReply(selectReplyIndex[1]);
                      } else {
                        addNewComment();
                      }

                      textEditingController.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: PRIMARY50_COLOR,
                    ),
                    child: const Text(
                      "네",
                      style: TextStyle(fontSize: 13, color: PRIMARY_COLOR),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: PRIMARY50_COLOR,
                    ),
                    child: const Text(
                      "아니요",
                      style: TextStyle(fontSize: 13, color: PRIMARY_COLOR),
                    ),
                  ),
                ],
              ),
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    final memberState = ref.watch(memberStateNotifierProvider);
    int myId = -1;
    String myEmail = "";
    if (memberState is MemberModel) {
      myId = memberState.id;
      myEmail = memberState.email;
    }
    ref.watch(imageStateProvider);
    List<int> selectCommentIndex = ref.watch(commentStateProvider);
    List<int> selectReplyIndex = ref.watch(replyStateProvider);
    if (selectCommentIndex[2] != -1) {
      // Delete comment.
      deleteComment(selectCommentIndex[2]);
    } else if (selectReplyIndex[2] != -1) {
      // Delete Reply
      deleteReply(selectReplyIndex[2]);
    }
    if ((selectCommentIndex[0] != -1 ||
            selectCommentIndex[1] != -1 ||
            selectReplyIndex[1] != -1) &&
        firstTime) {
      // AddReply, ModifyComment, ModifyReply -> show keyboard
      FocusScope.of(context).requestFocus(_focusNode);
      firstTime = false;
    }
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
              onPressed: notification,
              icon: myId == widget.board.userId
                  ? const Icon(Icons.notifications_none)
                  : const Icon(Icons.notifications_off_outlined),
            ),
            IconButton(
              onPressed: () {
                boardMore(myId == widget.board.userId);
              },
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            renderBoardDetail(myId == widget.board.userId),
            RenderCommentList(
                ref: ref,
                controller: controller,
                selectCommentIndex: selectCommentIndex,
                selectReplyIndex: selectReplyIndex,
                myEmail: myEmail,
                myId: myId),
            renderTextField(selectCommentIndex, selectReplyIndex),
            KeyboardVisibilityBuilder(
              builder: (p0, isKeyboardVisible) {
                return isKeyboardVisible
                    ? const SizedBox(
                        height: 0,
                      )
                    : const SizedBox(
                        height: 40,
                      );
              },
            ),
          ],
        ));
  }

  Widget renderBoardDetail(bool isMine) {
    ref.watch(networkImageStateProvider);
    return FutureBuilder(
      future: ref.watch(boardAddProvider).get(widget.board.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('이미 삭제된 글입니다.');
        } else {
          MsgBoardDetailResponseModel boardDetail =
              snapshot.data ?? widget.board as MsgBoardDetailResponseModel;
          return Board(
            board: boardDetail,
            titleSize: 13,
            isMine: isMine,
          );
        }
      },
    );
  }

  Widget renderTextField(selectCommentIndex, selectReplyIndex) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focusNode,
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
                  child: const Icon(
                    Icons.send,
                    color: PRIMARY50_COLOR,
                    size: 30,
                  ),
                  onTap: () async {
                    if (textEditingController.text == "") {
                      return;
                    }
                    try {
                      var dio = Dio();
                      Response contentCheck = await dio.post(
                          '$pythonIP/predict/',
                          data: {"message": textEditingController.text});
                      debugPrint(
                          "titleCheck : ${contentCheck.data["profanity"]}");
                      if (contentCheck.data["profanity"]) {
                        filterDialog(
                            "댓글에 비속어가 포함되어 있는 경우 서비스 이용에 제한이 있을 수 있습니다. 정말 등록하시겠습니까?",
                            selectCommentIndex,
                            selectReplyIndex);
                      } else {
                        if (selectCommentIndex[0] != -1) {
                          // Upload Reply
                          addNewReply(selectCommentIndex[0]);
                        } else if (selectCommentIndex[1] != -1) {
                          // Modify Comment속
                          modifyComment(selectCommentIndex[1]);
                        } else if (selectReplyIndex[1] != -1) {
                          // Modify Reply
                          modifyReply(selectReplyIndex[1]);
                        } else {
                          addNewComment();
                        }

                        textEditingController.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                    } catch (e) {
                      debugPrint("upload_content_predict : ${e.toString()}");
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RenderCommentList extends StatelessWidget {
  const RenderCommentList({
    super.key,
    required this.ref,
    required this.controller,
    required this.selectCommentIndex,
    required this.selectReplyIndex,
    required this.myEmail,
    required this.myId,
  });

  final WidgetRef ref;
  final ScrollController controller;
  final List<int> selectCommentIndex;
  final List<int> selectReplyIndex;
  final String myEmail;
  final int myId;

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(commentPaginationProvider);

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
    for (int i = 0; i < cp.data.length; i++) {
      if (cp.data[i].isBlockedUser) {
        cp.data.removeAt(i);
      }
    }

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          ref
              .read(commentPaginationProvider.notifier)
              .paginate(forceRefetch: true);
          ref.read(myCommentStateNotifierProvider.notifier).lastId =
              9223372036854775807;
          ref
              .read(myCommentStateNotifierProvider.notifier)
              .paginate(forceRefetch: true);
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller,
          itemCount: cp.data.length,
          itemBuilder: (_, index) {
            final CommentModel comment = cp.data[index];
            // debugPrint("$index 번째 댓글 : ${comment.content}");
            return Comment(
              comment: comment,
              selectComment: selectCommentIndex[0] == comment.id ||
                  selectCommentIndex[1] == comment.id,
              selectReplyIndex: selectReplyIndex[1],
              isMine: myEmail == comment.userInformation.email,
              myId: myId,
            );
          },
          separatorBuilder: (_, index) {
            return const SizedBox(
              height: 1.0,
            );
          },
        ),
      ),
    );
  }
}
