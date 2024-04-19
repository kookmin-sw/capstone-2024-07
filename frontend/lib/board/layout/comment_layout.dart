import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/model/comment_model.dart';
import 'package:frontend/board/layout/reply_layout.dart';
import 'package:frontend/board/layout/text_with_icon.dart';

class Comment extends ConsumerStatefulWidget {
  final CommentModel comment;
  final bool selectComment;
  final int selectReplyIndex;
  final bool isMine;
  final int myId;
  const Comment({
    super.key,
    required this.comment,
    required this.selectComment,
    required this.selectReplyIndex,
    required this.isMine,
    required this.myId,
  });

  @override
  ConsumerState<Comment> createState() => _CommentState();
}

class _CommentState extends ConsumerState<Comment>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  List<ReplyModel> replies = [];

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    replies = widget.comment.replies;
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
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: BODY_TEXT_COLOR.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
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
                      widget.comment.userInformation.nickname,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: widget.selectComment ? PRIMARY_COLOR : null,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      changeTime(widget.comment.createdAt),
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
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Row(
                      children: [
                        TextWithIcon(
                          icon: Icons.favorite_outline_rounded,
                          iconSize: 15,
                          text: widget.comment.likeCount.count.toString(),
                          commentId:
                              widget.comment.deleted ? -3 : widget.comment.id,
                          postId: -1,
                          replyId: -1,
                          isClicked: widget.comment.isLiked,
                          isMine: widget.isMine,
                        ),
                        TextWithIcon(
                          icon: Icons.chat_outlined,
                          iconSize: 15,
                          text: widget.comment.replies.length.toString(),
                          commentId:
                              widget.comment.deleted ? -2 : widget.comment.id,
                          postId: -1,
                          replyId: -1,
                          isClicked: false,
                          isMine: widget.isMine,
                        ),
                        TextWithIcon(
                          icon: Icons.more_horiz,
                          iconSize: 20,
                          text: "-1",
                          commentId: widget.comment.deleted
                              ? -3
                              : widget.isMine
                                  ? widget.comment.id
                                  : -2,
                          postId: -1,
                          replyId: -1,
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
              widget.comment.content,
              style: TextStyle(
                fontSize: 10,
                color: widget.selectComment ? PRIMARY_COLOR : null,
              ),
            ),
            for (var reply in replies)
              Reply(
                reply: reply,
                selectReply: widget.selectReplyIndex == reply.id,
                isMine: widget.myId == reply.userId,
                myId: widget.myId,
              )
          ],
        ),
      ),
    );
  }
}
