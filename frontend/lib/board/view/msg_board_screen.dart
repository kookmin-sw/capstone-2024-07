import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/model/comment_model.dart';
import 'package:frontend/board/model/msg_board_detail_response_model.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/board/provider/board_add_provider.dart';
import 'package:frontend/board/provider/board_state_notifier_provider.dart';
import 'package:frontend/board/provider/comment_provider.dart';
import 'package:frontend/board/provider/comment_notifier_provider.dart';
import 'package:frontend/board/provider/reply_notifier_provider.dart';
import 'package:frontend/board/provider/reply_provider.dart';
import 'package:frontend/board/view/msg_board_add_screen.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/layout/board_layout.dart';
import 'package:frontend/board/layout/comment_layout.dart';
import 'package:frontend/common/const/data.dart';
import 'package:frontend/member/provider/member_repository_provider.dart';
import 'package:flutter_local_notifications/src/platform_specifics/android/enums.dart'
    as noti;

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
    ref
        .read(memberRepositoryProvider)
        .getMe()
        .then((value) => isMine = value.id == widget.board.userId);
    initNotification();
  }

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isMine = false;
  final FlutterLocalNotificationsPlugin notification =
      FlutterLocalNotificationsPlugin();

  void initNotification() async {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings settings =
        InitializationSettings(android: android, iOS: ios);
    await notification.initialize(settings);
  }

  void sendNotification() async {
    NotificationDetails details = const NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      android: AndroidNotificationDetails(
        "1",
        "test",
        importance: Importance.max,
        priority: noti.Priority.high,
      ),
    );

    await notification.show(0, "title", "body", details);
    // TODO : Add 'payload : router path'
  }

  void addNewComment() async {
    final requestData = {
      'postId': widget.board.id.toInt(),
      'content': textEditingController.text,
    };
    await ref.watch(commentProvider).post(requestData);
    setState(() {});
  }

  void addNewReply(int commentId) async {
    final requestData = {
      'commentId': commentId,
      'content': textEditingController.text,
    };
    await ref.watch(replyProvider).post(requestData);
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
    ref.read(replyStateProvider.notifier).add(1, -1);
  }

  void deleteComment(int commentId) async {
    await ref.watch(commentProvider).delete(commentId);
    ref.read(commentStateProvider.notifier).add(2, -1);
  }

  void deleteReply(int replyId) async {
    await ref.watch(replyProvider).delete(replyId);
    ref.read(replyStateProvider.notifier).add(2, -1);
  }

  void boardMore() {
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
                content: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("글의 수정 권한이 없습니다."),
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
                        child: const Text("확인"),
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

  void subscribeNotification() {
    // TODO : cancel Notification

    SSEClient.subscribeToSSE(
        method: SSERequestType.GET,
        url: 'http://$ip/api/notifications/${widget.board.id}',
        header: {"accessToken": "true"}).listen((event) {
      debugPrint('subscribe! ${event.id} | ${event.event} | ${event.data}');
    });
  }

  @override
  Widget build(BuildContext context) {
    List<int> selectCommentIndex = ref.watch(commentStateProvider);
    List<int> selectReplyIndex = ref.watch(replyStateProvider);
    if (selectCommentIndex[2] != -1) {
      // Delete comment.
      deleteComment(selectCommentIndex[2]);
    } else if (selectReplyIndex[2] != -1) {
      // Delete Reply
      deleteReply(selectReplyIndex[2]);
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
              onPressed: subscribeNotification,
              icon: isMine
                  ? const Icon(Icons.notifications_none)
                  : const Icon(Icons.notifications_off_outlined),
            ),
            IconButton(
              onPressed: boardMore,
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder(
              future: ref.watch(boardAddProvider).get(widget.board.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  MsgBoardDetailResponseModel boardDetail = snapshot.data ??
                      widget.board as MsgBoardDetailResponseModel;
                  return Board(
                    board: boardDetail,
                    titleSize: 13,
                  );
                }
              },
            ),
            FutureBuilder(
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

                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    scrollController
                        .jumpTo(scrollController.position.maxScrollExtent);
                  });

                  return Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: comments.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Comment(
                          comment: comments[index],
                          selectComment:
                              selectCommentIndex[0] == comments[index].id ||
                                  selectCommentIndex[1] == comments[index].id,
                          selectReplyIndex: selectReplyIndex[1],
                        );
                      },
                    ),
                  );
                }
              },
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
