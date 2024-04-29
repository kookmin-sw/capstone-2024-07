import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/model/msg_board_detail_response_model.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/layout/category_circle_layout.dart';
import 'package:frontend/board/layout/text_with_icon.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Board extends ConsumerWidget {
  final MsgBoardDetailResponseModel board;
  final bool isMine;
  final double titleSize;
  const Board({
    super.key,
    required this.board,
    required this.titleSize,
    required this.isMine,
  });

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
  Widget build(BuildContext context, WidgetRef ref) {
    MsgBoardResponseModel boardForImageViewer = board;
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
                  category:
                      categoryCodesReverseList[board.communityTitle].toString(),
                  type: false,
                ),
                Row(
                  children: [
                    TextWithIcon(
                      icon: Icons.favorite_outline_rounded,
                      iconSize: 15,
                      text: board.count.likeCount.toString(),
                      commentId: -1,
                      postId: board.id,
                      replyId: -1,
                      isClicked: board.likedBy,
                      isMine: isMine,
                    ),
                    TextWithIcon(
                      icon: Icons.chat_outlined,
                      iconSize: 15,
                      text: board.count.commentReplyCount.toString(),
                      commentId: -1,
                      postId: -1,
                      replyId: -1,
                      isClicked: false,
                      isMine: isMine,
                    ),
                    TextWithIcon(
                      icon: Icons.star_outline_rounded,
                      iconSize: 18,
                      text: board.count.scrapCount.toString(),
                      commentId: -1,
                      postId: board.id,
                      replyId: -1,
                      isClicked: board.isScrapped,
                      isMine: isMine,
                    ),
                    const SizedBox(
                      width: 6,
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
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ImageViewer(
                    board: boardForImageViewer,
                  ),
                  Text(
                    "${changeTime(board.createdDateTime)} | ${board.userNickname}",
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
                              imageLink: board.images,
                              index: board.images.indexOf(imageLink),
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
  ShowImageBigger({super.key, required this.imageLink, required this.index});
  final List<String> imageLink;
  final int index;
  final PageController _controller = PageController();

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
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              for (var i = 0; i < imageLink.length; i++)
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Center(
                    child: PhotoView(
                      imageProvider: NetworkImage(imageLink[i]),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    ),
                  ),
                ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 500),
            child: Center(
              child: SmoothPageIndicator(
                effect: const WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  type: WormType.thinUnderground,
                  dotColor: Colors.white,
                  activeDotColor: PRIMARY_COLOR,
                ),
                controller: _controller,
                count: imageLink.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
