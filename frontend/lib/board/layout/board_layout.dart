import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/layout/category_circle_layout.dart';
import 'package:frontend/board/layout/text_with_icon.dart';
import 'package:photo_view/photo_view.dart';

class Board extends ConsumerWidget {
  final MsgBoardResponseModel board;
  final double titleSize;
  const Board({
    super.key,
    required this.board,
    required this.titleSize,
  });

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
      margin: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryCircle(
                  category: board.communityTitle,
                  type: false,
                ),
                Row(
                  children: [
                    TextWithIcon(
                      icon: Icons.favorite_outline_rounded,
                      iconSize: 15,
                      text: board.count.likeCount.toString(),
                      ref: ref,
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    TextWithIcon(
                      icon: Icons.chat_outlined,
                      iconSize: 15,
                      text: board.count.commentReplyCount.toString(),
                      ref: ref,
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    TextWithIcon(
                      icon: Icons.star_outline_rounded,
                      iconSize: 18,
                      text: board.count.scrapCount.toString(),
                      ref: ref,
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    board.postTitle,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    board.postContent,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ImageViewer(
                    board: board,
                  ),
                  Text(
                    "${board.createdDateTime} | ${board.userNickname}",
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageViewer extends StatelessWidget {
  final MsgBoardResponseModel board;
  const ImageViewer({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    if (board.images.isEmpty) {
      return const SizedBox(
        height: 5,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: SizedBox(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var imageLink in board.images)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowImageBigger(
                              imageLink: imageLink,
                            ),
                        fullscreenDialog: true),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.2),
                  ),
                  width: 100,
                  child: Image(
                    image: NetworkImage(imageLink),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ShowImageBigger extends StatelessWidget {
  const ShowImageBigger({super.key, required this.imageLink});
  final String imageLink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageLink),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ),
    );
  }
}
