import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/layout/text_with_icon.dart';
import 'package:frontend/board/model/comment_model.dart';
import 'package:frontend/common/const/colors.dart';

class Reply extends ConsumerStatefulWidget {
  final ReplyModel reply;
  final bool selectReply;
  final bool isMine;
  final int myId;
  const Reply({
    super.key,
    required this.reply,
    required this.selectReply,
    required this.isMine,
    required this.myId,
  });

  @override
  ConsumerState<Reply> createState() => _Reply();
}

class _Reply extends ConsumerState<Reply> {
  @override
  void initState() {
    super.initState();
  }

  String changeTime(String time) {
    String dt = DateTime.now().toString(); //2022-12-05 20:09:14.322471
    String nowDate = dt.replaceRange(11, dt.length, ""); //2022-12-05
    String nowTime = dt.replaceRange(0, 11, ""); //20:09:14.322471
    nowTime = nowTime.replaceRange(9, nowTime.length, ""); //20:09:14

    time = time.replaceAll('T', " ");
    String uploadDate = time.replaceRange(11, time.length, "");
    String uploadTime = time.replaceRange(0, 11, "");
    uploadTime = uploadTime.replaceRange(9, uploadTime.length, "");

    if (nowDate == uploadDate) {
      if (nowTime.replaceRange(2, nowTime.length, "") ==
          uploadTime.replaceRange(2, nowTime.length, "")) {
        // same hour
        String nowTmp = nowTime.replaceRange(0, 3, "");
        nowTmp = nowTmp.replaceRange(2, nowTmp.length, "");
        String uploadTmp = uploadTime.replaceRange(0, 3, "");
        uploadTmp = uploadTmp.replaceRange(2, uploadTmp.length, "");

        if (int.parse(nowTmp) - int.parse(uploadTmp) == 0) {
          return "방금전";
        } else {
          return "${int.parse(nowTmp) - int.parse(uploadTmp)}분전";
        }
      } else if (int.parse(nowTime.replaceRange(2, nowTime.length, "")) -
              int.parse(uploadTime.replaceRange(2, nowTime.length, "")) ==
          1) {
        // different 1 hour
        String nowTmp = nowTime.replaceRange(0, 3, "");
        nowTmp = nowTmp.replaceRange(2, nowTmp.length, "");
        String uploadTmp = uploadTime.replaceRange(0, 3, "");
        uploadTmp = uploadTmp.replaceRange(2, uploadTmp.length, "");

        if (int.parse(uploadTmp) - int.parse(nowTmp) > 0) {
          return "${int.parse(uploadTmp) - int.parse(nowTmp)}분전";
        }
      }
    }

    return time.replaceRange(16, time.length, "");
  }

  @override
  Widget build(BuildContext context) {
    bool myClicked = false;
    for (var likes in widget.reply.likeCount.likes) {
      myClicked = likes.usersId == widget.myId;
    }
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Transform.flip(
              flipY: true,
              child: const Icon(
                Icons.turn_right_rounded,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: BODY_TEXT_COLOR.withOpacity(0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                    bottom: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.reply.userInformation.nickname,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: widget.selectReply
                                      ? PRIMARY_COLOR
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                changeTime(widget.reply.createdAt),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: BODY_TEXT_COLOR.withOpacity(0.1),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              child: Row(
                                children: [
                                  TextWithIcon(
                                    icon: Icons.favorite_outline_rounded,
                                    iconSize: 15,
                                    text:
                                        widget.reply.likeCount.count.toString(),
                                    commentId: -1,
                                    postId: -1,
                                    replyId: widget.reply.id,
                                    isClicked: myClicked,
                                    isMine: widget.isMine,
                                  ),
                                  TextWithIcon(
                                    icon: Icons.more_horiz,
                                    iconSize: 20,
                                    text: "-1",
                                    commentId: -1,
                                    postId: -1,
                                    replyId:
                                        widget.isMine ? widget.reply.id : -2,
                                    isClicked: false,
                                    isMine: widget.isMine,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.reply.content,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color:
                              widget.selectReply ? PRIMARY_COLOR : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
