import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/layout/recruitment_comment_layout.dart';
import 'package:frontend/board/layout/study_board_layout.dart';
import 'package:frontend/board/layout/text_with_icon.dart';
import 'package:frontend/board/model/exception_model.dart';
import 'package:frontend/board/model/recruitment_comment_model.dart';
import 'package:frontend/board/model/recruitment_detail_response_model.dart';
import 'package:frontend/board/model/recruitment_response_model.dart';
import 'package:frontend/board/provider/anonymous_provider.dart';
import 'package:frontend/board/provider/block_provider.dart';
import 'package:frontend/board/provider/board_state_notifier_provider.dart';
import 'package:frontend/board/provider/comment_notifier_provider.dart';
import 'package:frontend/board/provider/image_provider.dart';
import 'package:frontend/board/provider/recruitment_add_provider.dart';
import 'package:frontend/board/provider/recruitment_comment_pagination_provider.dart';
import 'package:frontend/board/provider/recruitment_comment_provider.dart';
import 'package:frontend/board/provider/recruitment_reply_provider.dart';
import 'package:frontend/board/provider/recruitment_state_notifier_provider.dart';
import 'package:frontend/board/provider/reply_notifier_provider.dart';
import 'package:frontend/board/provider/report_provider.dart';
import 'package:frontend/board/view/msg_board_add_screen.dart';
import 'package:frontend/common/const/colors.dart';

import 'package:frontend/common/model/cursor_pagination_model.dart';
import 'package:frontend/member/model/member_model.dart';
import 'package:frontend/member/provider/member_state_notifier_provider.dart';
import 'package:frontend/member/provider/mypage/my_post_state_notifier_provider.dart';

class StudyBoardScreen extends ConsumerStatefulWidget {
  final RecruitmentResponseModel board;
  const StudyBoardScreen({super.key, required this.board});

  @override
  ConsumerState<StudyBoardScreen> createState() => _StudyBoardScreenState();
}

class _StudyBoardScreenState extends ConsumerState<StudyBoardScreen> {
  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController controller = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool firstTime = true;
  double controllerOffset = 0;

  void moveScroll() {
    controller.animateTo(controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void scrollListener() {
    if (controller.offset > controller.position.maxScrollExtent - 150) {
      ref.read(recruitmentCommentPaginationProvider.notifier).paginate(
            fetchMore: true,
          );
    }
  }

  void refresh() async {
    controllerOffset = controller.offset;

    await ref
        .read(recruitmentCommentPaginationProvider.notifier)
        .paginate(forceRefetch: true);
    // TODO : my recruitment comment
    // ref.read(myCommentStateNotifierProvider.notifier).lastId =
    //     9223372036854775807;
    // ref
    //     .read(myCommentStateNotifierProvider.notifier)
    //     .paginate(forceRefetch: true);

    firstTime = true;

    while (controller.position.maxScrollExtent < controllerOffset) {
      await controller.animateTo(controllerOffset + 30,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void addNewComment() async {
    final requestData = {
      'recruitmentId': widget.board.id.toInt(),
      'content': textEditingController.text,
      'isAnonymous': ref.watch(isAnonymousStateProvider),
    };
    try {
      await ref.watch(recruitmentCommentProvider).post(requestData);
      refresh();
      moveScroll();
    } on DioException catch (e) {
      if (e.response != null) {
        Map<String, dynamic> data = e.response!.data;
        ExceptionModel exc = ExceptionModel.fromJson(data);
        notAllowed(exc.message);
      }
    }
  }

  void addNewReply(int commentId) async {
    final requestData = {
      'commentId': commentId,
      'content': textEditingController.text,
      'isAnonymous': ref.watch(isAnonymousStateProvider),
    };

    try {
      await ref.watch(recruitmentReplyProvider).post(requestData);
    } on DioException catch (e) {
      if (e.response != null) {
        Map<String, dynamic> data = e.response!.data;
        ExceptionModel exc = ExceptionModel.fromJson(data);
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
    await ref.watch(recruitmentCommentProvider).modify(commentId, requestData);
    await ref.read(commentStateProvider.notifier).add(1, -1);
    refresh();
  }

  void modifyReply(int replyId) async {
    final requestData = {
      'content': textEditingController.text,
    };
    await ref.watch(recruitmentReplyProvider).modify(replyId, requestData);
    await ref.read(replyStateProvider.notifier).add(1, -1);
    refresh();
  }

  void deleteComment(int commentId) async {
    await ref.watch(recruitmentCommentProvider).delete(commentId);
    ref.read(commentStateProvider.notifier).add(2, -1);
    refresh();
  }

  void deleteReply(int replyId) async {
    await ref.watch(recruitmentReplyProvider).delete(replyId);
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
    notAllowed("신고되었습니다.\n검토까지는 최대 24시간 소요됩니다.");
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
                    "신고 사유를 선택해주세요.\n신고 사유에 맞지 않는 신고일 경우,\n해당 신고는 처리되지 않습니다.\n누적 신고횟수가 10회 이상인 게시글은 삭제되고\n해당 글의 작성자는 일정 기간 글과 댓글을 작성할 수 없게 됩니다.",
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
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
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: BODY_TEXT_COLOR,
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
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: BODY_TEXT_COLOR,
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
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: BODY_TEXT_COLOR,
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
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: BODY_TEXT_COLOR,
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
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: BODY_TEXT_COLOR,
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
                                    .watch(recruitmentAddProvider)
                                    .delete(widget.board.id);
                                await ref
                                    .read(recruitmentStateNotifierProvider
                                        .notifier)
                                    .paginate(forceRefetch: true);
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
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: BODY_TEXT_COLOR,
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
                                      isRecruitment: true,
                                      board: null,
                                      recruitmentBoard: widget.board,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "수정하기",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
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
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: BODY_TEXT_COLOR,
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
                                isReally();
                              },
                              child: const Text(
                                "차단하기",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
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

  void isReally() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    "이 작성자의 게시물이 목록에 노출되지 않으며, 다시 해제할 수 없습니다.",
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
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
                      ref.read(blockProvider).post(widget.board.userId);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: PRIMARY50_COLOR,
                    ),
                    child: const Text(
                      "확인",
                      style: TextStyle(
                        fontSize: 13,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
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
                      "취소",
                      style: TextStyle(
                        fontSize: 13,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }));
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
                      fontWeight: FontWeight.w400,
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
                      style: TextStyle(
                        fontSize: 13,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.w400,
                      ),
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: PRIMARY10_COLOR,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          shadowColor: Colors.black,
          elevation: 3,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              ref.read(commentStateProvider.notifier).add(0, -1);
              ref.read(commentStateProvider.notifier).add(1, -1);
              ref.read(replyStateProvider.notifier).add(1, -1);
              Navigator.pop(context);
            },
          ),
          title: Text(
            categoryCodesReverseList2[widget.board.type].toString(),
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w400,
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
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  refresh();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: controller,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      renderBoardDetail(myId == widget.board.userId),
                      RenderCommentList(
                          ref: ref,
                          controller: controller,
                          selectCommentIndex: selectCommentIndex,
                          selectReplyIndex: selectReplyIndex,
                          myEmail: myEmail,
                          myId: myId,
                          boardUserId: widget.board.userId),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                renderTextField(selectCommentIndex, selectReplyIndex),
                KeyboardVisibilityBuilder(
                  builder: (p0, isKeyboardVisible) {
                    return isKeyboardVisible
                        ? const SizedBox(
                            height: 10,
                          )
                        : Container(
                            height: 40,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                          );
                  },
                ),
              ],
            ),
          ],
        ));
  }

  Widget renderBoardDetail(bool isMine) {
    return FutureBuilder(
      future: ref.watch(recruitmentAddProvider).get(widget.board.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text(
            '이미 삭제된 글입니다.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          );
        } else {
          RecruitmentDetailResponseModel boardDetail =
              snapshot.data ?? widget.board as RecruitmentDetailResponseModel;
          return StudyBoard(
              recruitmentDetailResponseModel: boardDetail,
              titleSize: 14,
              isMine: isMine);
        }
      },
    );
  }

  Widget renderTextField(selectCommentIndex, selectReplyIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: TEXT_FIELD_COLORS),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                TextWithIcon(
                  icon: Icons.check_box_outline_blank_rounded,
                  iconSize: 17,
                  text: "익명",
                  commentId: -1,
                  postId: -1,
                  replyId: -1,
                  isClicked: ref.watch(isAnonymousStateProvider),
                  isMine: false,
                  userId: -1,
                ),
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    controller: textEditingController,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: '입력',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      border: InputBorder.none,
                      suffixIcon: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: TEXT_FIELD_SEND_COLOR,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Icon(
                              Icons.arrow_upward_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        onTap: () async {
                          if (textEditingController.text == "") {
                            return;
                          }
                          try {
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
                          } catch (e) {
                            debugPrint(
                                "upload_content_predict : ${e.toString()}");
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
    required this.boardUserId,
  });

  final WidgetRef ref;
  final ScrollController controller;
  final List<int> selectCommentIndex;
  final List<int> selectReplyIndex;
  final String myEmail;
  final int myId;
  final int boardUserId;

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(recruitmentCommentPaginationProvider);

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
    for (int i = cp.data.length - 1; i >= 0; i--) {
      if (cp.data[i].isBlockedUser) {
        cp.data.removeAt(i);
      }
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cp.data.length,
      itemBuilder: (_, index) {
        final RecruitmentCommentModel recruitmentComment = cp.data[index];
        // debugPrint("$index 번째 댓글 : ${comment.content}");
        return RecruitmentComment(
          recruitmentComment: recruitmentComment,
          selectComment: selectCommentIndex[0] == recruitmentComment.id ||
              selectCommentIndex[1] == recruitmentComment.id,
          selectReplyIndex: selectReplyIndex[1],
          isMine: myEmail == recruitmentComment.userInformation.email,
          myId: myId,
          boardUserId: boardUserId,
        );
      },
      separatorBuilder: (_, index) {
        return const SizedBox(
          height: 1.0,
        );
      },
    );
  }
}
