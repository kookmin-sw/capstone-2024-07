import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/layout/big_button_layout.dart';
import 'package:frontend/board/model/msg_board_detail_response_model.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/layout/category_circle_layout.dart';

import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  void _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MsgBoardResponseModel boardForImageViewer = board;

    String allText = board.postContent;
    List<String> splitText = allText.split("\n");

    List<TextSpan> spans = [];
    for (String t in splitText) {
      if (t.startsWith('http')) {
        spans.add(
          TextSpan(
            text: '$t\n',
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => _launchUrl(t),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: '$t\n',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: BOX_LINE_COLOR,
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
          left: 10,
          right: 10,
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
                ),
                if (board.communityTitle == "STUDY")
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: ACTIVE_COLOR,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "온라인",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: STUDY_PERSON_BACK_COLOR,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "2",
                              style: TextStyle(
                                fontSize: 10,
                                color: STUDY_PERSON_COLOR,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "명 남음",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              board.postTitle,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            RichText(
              softWrap: true,
              text: TextSpan(
                children: spans,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ImageViewer(
              board: boardForImageViewer,
            ),
            if (board.communityTitle == "STUDY")
              const Text(
                "#MSA #아키텍처",
                style: TextStyle(
                  fontSize: 10,
                  color: TAG_COLOR,
                  fontWeight: FontWeight.w400,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${changeTime(board.createdDateTime)} | ${board.userNickname}",
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    BigButton(
                      icon: Icons.favorite_outline_rounded,
                      iconSize: 13,
                      text: board.count.likeCount.toString(),
                      postId: board.id,
                      isClicked: board.likedBy,
                      isMine: isMine,
                      userId: board.userId,
                      isRecruitment: false,
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    BigButton(
                      icon: Icons.star_outline_rounded,
                      iconSize: 20,
                      text: board.count.scrapCount.toString(),
                      postId: board.id,
                      isClicked: board.isScrapped,
                      isMine: isMine,
                      userId: board.userId,
                      isRecruitment: false,
                    ),
                  ],
                ),
              ],
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

    if (board.images.length == 1) {
      double width = MediaQuery.of(context).size.width;

      return Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: SizedBox(
          width: width,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowImageBigger(
                          imageLink: board.images,
                          index: board.images.indexOf(board.images[0]),
                        ),
                    fullscreenDialog: true),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: NetworkImage(board.images[0]),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: SizedBox(
        height: 150,
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
                    right: 20,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: NetworkImage(imageLink),
                    ),
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
