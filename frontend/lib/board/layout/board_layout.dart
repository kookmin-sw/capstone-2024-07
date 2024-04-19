import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/model/msg_board_detail_response_model.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/layout/category_circle_layout.dart';
import 'package:frontend/board/layout/text_with_icon.dart';
import 'package:photo_view/photo_view.dart';

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
    String dt = DateTime.now().toString(); //2022-12-05 20:09:14.322471
    String nowDate = dt.replaceRange(11, dt.length, ""); //2022-12-05
    String nowTime = dt.replaceRange(0, 11, ""); //20:09:14.322471
    nowTime = nowTime.replaceRange(9, nowTime.length, ""); //20:09:14

    debugPrint("nowDate : $nowDate, nowTime : $nowTime");

    time = time.replaceAll('T', " ");
    String uploadDate = time.replaceRange(11, time.length, "");
    String uploadTime = time.replaceRange(0, 11, "");
    uploadTime = uploadTime.replaceRange(9, uploadTime.length, "");

    debugPrint("uploadDate : $uploadDate, uploadTime : $uploadTime");

    if (nowDate == uploadDate) {
      if (nowTime.replaceRange(2, nowTime.length, "") ==
          uploadTime.replaceRange(2, nowTime.length, "")) {
        // same hour
        String nowTmp = nowTime.replaceRange(0, 3, "");
        nowTmp = nowTmp.replaceRange(2, nowTmp.length, "");
        String uploadTmp = uploadTime.replaceRange(0, 3, "");
        uploadTmp = uploadTmp.replaceRange(2, uploadTmp.length, "");

        debugPrint("nowTmp : $nowTmp, uploadTmp : $uploadTmp");

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

        debugPrint("nowTmp : $nowTmp, uploadTmp : $uploadTmp");

        return "${int.parse(nowTmp) - int.parse(uploadTmp)}분전";
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
                    const SizedBox(
                      width: 13,
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
                    const SizedBox(
                      width: 13,
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
