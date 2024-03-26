import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/layout/text_with_icon.dart';
import 'package:frontend/board/model/comment_model.dart';
import 'package:frontend/common/const/colors.dart';

class Reply extends ConsumerWidget {
  final ReplyModel reply;
  const Reply({
    super.key,
    required this.reply,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    top: 10,
                    left: 15,
                    right: 15,
                    bottom: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            reply.userInformation.name,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: BODY_TEXT_COLOR.withOpacity(0.1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: Row(
                                children: [
                                  TextWithIcon(
                                    icon: Icons.favorite_outline_rounded,
                                    iconSize: 15,
                                    text: reply.likeCount.count.toString(),
                                    ref: ref,
                                  ),
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: 댓글 수정, 삭제, 알림설정
                                    },
                                    child: TextWithIcon(
                                      icon: Icons.more_horiz,
                                      iconSize: 20,
                                      text: "-1",
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
                        reply.content,
                        style: const TextStyle(
                          fontSize: 10,
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
