import 'package:flutter/material.dart';

import '../../common/const/colors.dart';
import '../const/categorys.dart';
import '../model/msg_board_response_model.dart';
import 'text_with_icon_for_view.dart';

class BoardCard extends StatelessWidget {
  final int id;
  final int userId;
  final String userNickname;
  final String universityName;
  final int communityId;
  final String communityTitle;
  final String postTitle;
  final String postContent;
  final List<String> images;
  final ReactCountModel count;
  final bool isQuestion;
  final int imageCount;
  final String createdDateTime;

  const BoardCard({
    required this.id,
    required this.userId,
    required this.userNickname,
    required this.universityName,
    required this.communityId,
    required this.communityTitle,
    required this.postTitle,
    required this.postContent,
    required this.images,
    required this.count,
    required this.isQuestion,
    required this.imageCount,
    required this.createdDateTime,
    super.key,
  });

  factory BoardCard.fromModel(
      {required MsgBoardResponseModel msgBoardResponseModel}) {
    return BoardCard(
      id: msgBoardResponseModel.id,
      userId: msgBoardResponseModel.userId,
      userNickname: msgBoardResponseModel.userNickname,
      universityName: msgBoardResponseModel.universityName,
      communityId: msgBoardResponseModel.communityId,
      communityTitle: msgBoardResponseModel.communityTitle,
      postTitle: msgBoardResponseModel.postTitle,
      postContent: msgBoardResponseModel.postContent,
      images: msgBoardResponseModel.images,
      count: msgBoardResponseModel.count,
      isQuestion: msgBoardResponseModel.isQuestion,
      imageCount: msgBoardResponseModel.imageCount,
      createdDateTime: msgBoardResponseModel.createdDateTime,
    );
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

  String _formatText(String text, int maxLength) {
    // 줄바꿈을 기준으로 첫 줄만 추출
    String firstLine = text.split('\n')[0];
    if (firstLine.length > maxLength) {
      return '${firstLine.substring(0, maxLength)}...';
    }
    return firstLine;
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
                _renderCategoryCircleUi(
                    categoryCodesReverseList[communityTitle] ?? communityTitle),
                Row(
                  children: [
                    TextWithIconForView(
                      icon: Icons.favorite_outline_rounded,
                      iconSize: 15,
                      text: count.likeCount.toString(),
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    TextWithIconForView(
                      icon: Icons.chat_outlined,
                      iconSize: 15,
                      text: count.commentReplyCount.toString(),
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    TextWithIconForView(
                      icon: Icons.star_outline_rounded,
                      iconSize: 18,
                      text: count.scrapCount.toString(),
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    TextWithIconForView(
                      icon: Icons.photo_size_select_actual_outlined,
                      iconSize: 18,
                      text: imageCount.toString(),
                      color: Colors.black,
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
                    _formatText(postTitle, 40),
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatText(postContent, 80),
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${changeTime(createdDateTime)} | $userNickname",
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

  Widget _renderCategoryCircleUi(String category) {
    return Container(
      // category circle
      decoration: BoxDecoration(
        color: PRIMARY10_COLOR,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        child: Center(
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
