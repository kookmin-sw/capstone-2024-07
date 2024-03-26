import 'package:flutter/material.dart';
import 'package:frontend/board/model/comment_model.dart';
import 'package:frontend/common/const/colors.dart';

class Reply extends StatelessWidget {
  final ReplyModel reply;
  const Reply({
    super.key,
    required this.reply,
  });

  @override
  Widget build(BuildContext context) {
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
                    bottom: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reply.userInformation.name,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
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
