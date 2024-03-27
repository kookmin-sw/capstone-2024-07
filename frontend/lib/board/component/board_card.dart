import 'package:flutter/material.dart';

import '../../common/const/colors.dart';
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
      createdDateTime: msgBoardResponseModel.createdDateTime,
    );
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
                _renderCategoryCircleUi(communityTitle),
                Row(
                  children: [
                    TextWithIconForView(
                      icon: Icons.favorite_outline_rounded,
                      iconSize: 15,
                      text: count.likeCount.toString(),
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
                      text: 0.toString(),
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
                    postTitle,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    postContent,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "$createdDateTime | $userNickname",
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
