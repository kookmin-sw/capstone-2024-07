import 'package:flutter/material.dart';
import 'package:frontend/common/const/msg_board_list_model.dart';
import 'package:frontend/common/layout/text_with_icon.dart';

class BoardList extends StatelessWidget {
  final MsgBoardListModel board;
  const BoardList({super.key, required this.board});

  onButtonTap() {
    // TODO: make detail msgboard
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 213, 213, 213),
              width: 1,
            ),
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFBA84FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(board.category),
                    ),
                  ),
                  Row(
                    children: [
                      TextWithIcon(
                          icon: Icons.favorite_outline_rounded,
                          text: board.heart),
                      const SizedBox(
                        width: 13,
                      ),
                      TextWithIcon(
                          icon: Icons.chat_outlined, text: board.comment),
                      const SizedBox(
                        width: 13,
                      ),
                      TextWithIcon(
                          icon: Icons.star_outline_rounded,
                          text: board.favorite),
                      const SizedBox(
                        width: 13,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      board.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      board.preview,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
