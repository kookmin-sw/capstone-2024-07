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
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4.0,
              offset: const Offset(0, 3),
            )
          ]),
      margin: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
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
                    if (communityTitle != "STUDY")
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
                    if (communityTitle == "STUDY")
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatText(postTitle, 40),
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatText(postContent, 80),
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (communityTitle != "STUDY")
                  Text(
                    "${changeTime(createdDateTime)} | $userNickname",
                    style: const TextStyle(
                      fontSize: 8,
                      color: BOARD_CARD_TIME_COLOR,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                if (communityTitle == "STUDY")
                  const Row(
                    children: [
                      Text(
                        "2024.06.17~08.02",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "#통계학 #경진대회",
                        style: TextStyle(
                          fontSize: 10,
                          color: TAG_COLOR,
                          fontWeight: FontWeight.w400,
                        ),
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

  Widget _renderCategoryCircleUi(String category) {
    return Container(
      // category circle
      decoration: BoxDecoration(
        color: PRIMARY10_COLOR,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Center(
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
