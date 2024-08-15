import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/comment_model.dart';
import 'package:frontend/board/model/recruitment_comment_model.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/layout/reply_layout.dart';
import 'package:frontend/board/layout/text_with_icon.dart';

class RecruitmentComment extends ConsumerStatefulWidget {
  final RecruitmentCommentModel recruitmentComment;
  final bool selectComment;
  final int selectReplyIndex;
  final bool isMine;
  final int myId;
  final int boardUserId;

  const RecruitmentComment({
    super.key,
    required this.recruitmentComment,
    required this.selectComment,
    required this.selectReplyIndex,
    required this.isMine,
    required this.myId,
    required this.boardUserId,
  });

  @override
  ConsumerState<RecruitmentComment> createState() => _RecruitmentCommentState();
}

class _RecruitmentCommentState extends ConsumerState<RecruitmentComment>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  List<ReplyModel> replies = [];

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    replies = widget.recruitmentComment.replies;
    for (int i = replies.length - 1; i >= 0; i--) {
      if (replies[i].isBlockedUser) {
        replies.removeAt(i);
      }
    }
  }

  String changeTime(String time) {
    DateTime t = DateTime.parse(time);

    time = time.replaceAll('T', " ");

    if (DateTime.now().difference(t).inDays == 0) {
      int diffM = DateTime.now().difference(t).inMinutes;
      if (diffM < 60) {
        if (diffM == 0) {
          return "방금전";
        }
        return "$diffM분전";
      }
    }

    return time.replaceRange(16, time.length, "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: BOX_LINE_COLOR,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      widget.recruitmentComment.userInformation.nickname,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: widget.selectComment
                            ? PRIMARY_COLOR
                            : widget.boardUserId ==
                                    widget.recruitmentComment.userId
                                ? MY_COMMENT_TEXT_COLOR
                                : null,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      changeTime(widget.recruitmentComment.createdAt),
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: BODY_TEXT_COLOR,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Row(
                      children: [
                        TextWithIcon(
                          icon: Icons.chat_outlined,
                          iconSize: 15,
                          text: widget.recruitmentComment.replies.length
                              .toString(),
                          commentId: widget.recruitmentComment.deleted
                              ? -2
                              : widget.recruitmentComment.id,
                          postId: -1,
                          replyId: -1,
                          isClicked: false,
                          isMine: widget.isMine,
                          userId: widget.recruitmentComment.userId,
                        ),
                        TextWithIcon(
                          icon: Icons.more_horiz,
                          iconSize: 20,
                          text: "-1",
                          commentId: widget.recruitmentComment.deleted
                              ? -3
                              : widget.recruitmentComment.id,
                          postId: -1,
                          replyId: -1,
                          isClicked: false,
                          isMine: widget.isMine,
                          userId: widget.recruitmentComment.userId,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Text(
              widget.recruitmentComment.content,
              style: TextStyle(
                fontSize: 12,
                color: widget.selectComment ? PRIMARY_COLOR : null,
                fontWeight: FontWeight.w400,
              ),
            ),
            for (var reply in replies)
              Reply(
                reply: reply,
                selectReply: widget.selectReplyIndex == reply.id,
                isMine: widget.myId == reply.userId,
                myId: widget.myId,
                isWriter: widget.boardUserId == reply.userId,
              )
          ],
        ),
      ),
    );
  }
}
