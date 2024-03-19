import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/cocomment_model.dart';
import 'package:frontend/board/provider/cocomment_provider.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/model/comment_model.dart';
import 'package:frontend/board/layout/cocoment_layout.dart';
import 'package:frontend/board/layout/text_with_icon.dart';

class Comment extends StatefulWidget {
  final CommentModel comment;
  // TODO: comment of comment
  const Comment({super.key, required this.comment});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return _Comment(
      widget: widget,
      animationController: animationController,
    );
  }
}

class _Comment extends ConsumerWidget {
  const _Comment({
    super.key,
    required this.widget,
    required this.animationController,
  });

  final Comment widget;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CoCommentModel> cocomentlistinstance =
        ref.watch(cocommentStateProvider);
    return Contents(widget: widget, cocomentlistinstance: cocomentlistinstance);
  }
}

class Contents extends ConsumerWidget {
  const Contents({
    super.key,
    required this.widget,
    required this.cocomentlistinstance,
  });

  final Comment widget;
  final List<CoCommentModel> cocomentlistinstance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.comment.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: BODY_TEXT_COLOR.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: Row(
                      children: [
                        TextWithIcon(
                          icon: Icons.favorite_outline_rounded,
                          iconSize: 15,
                          text: widget.comment.likeCount,
                          canTap: true,
                          ref: ref,
                        ),
                        const SizedBox(
                          width: 13,
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: 대댓글 달기
                            // ref
                            //     .read(cocommentStateProvider.notifier)
                            //     .add(CoCommentModel(
                            //       "5",
                            //       widget.comment.postId,
                            //       widget.comment.commentId,
                            //       "3",
                            //       "익명5",
                            //       "",
                            //       "0",
                            //     ));
                          },
                          child: TextWithIcon(
                            icon: Icons.chat_outlined,
                            iconSize: 15,
                            text: "-1",
                            canTap: true,
                            ref: ref,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Text(
              widget.comment.content,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
            for (var cocoment in cocomentlistinstance)
              CoComment(cocoment: cocoment)
          ],
        ),
      ),
    );
  }
}
