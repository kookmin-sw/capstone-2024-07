import 'package:flutter/material.dart';
import 'package:frontend/board/model/recruitment_response_model.dart';

import '../../common/const/colors.dart';
import '../const/categorys.dart';
import 'text_with_icon_for_view.dart';

class StudyBoardCard extends StatelessWidget {
  final RecruitmentResponseModel recruitmentResponseModel;

  const StudyBoardCard({
    required this.recruitmentResponseModel,
    super.key,
  });

  String getTwoWord(int t) {
    if (t < 10) {
      return "0$t";
    } else {
      return "$t";
    }
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
    DateTime start = recruitmentResponseModel.startDateTime;
    DateTime end = recruitmentResponseModel.endDateTime;

    String date = "";
    if (!recruitmentResponseModel.isOngoing) {
      if (start.year == end.year) {
        date =
            "${start.year}.${getTwoWord(start.month)}.${getTwoWord(start.day)}~${getTwoWord(end.month)}.${getTwoWord(end.day)}";
      } else {
        date =
            "${start.year % 100}.${getTwoWord(start.month)}.${getTwoWord(start.day)}~${end.year % 100}.${getTwoWord(end.month)}.${getTwoWord(end.day)}";
      }
    }

    String hashTags = "";
    int hashTagsNum = 0;
    for (HashTagsModel h in recruitmentResponseModel.hashTags) {
      if (hashTagsNum < 2) {
        hashTags += "#${h.name} ";
        hashTagsNum++;
      } else {
        break;
      }
    }

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
                    categoryCodesReverseList2[recruitmentResponseModel.type] ??
                        recruitmentResponseModel.type),
                Row(
                  children: [
                    TextWithIconForView(
                      icon: Icons.chat_outlined,
                      iconSize: 15,
                      text:
                          recruitmentResponseModel.commentReplyCount.toString(),
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    TextWithIconForView(
                      icon: Icons.star_outline_rounded,
                      iconSize: 18,
                      text: recruitmentResponseModel.scrapCount.toString(),
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(
                      width: 13,
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
                      child: recruitmentResponseModel.limit != -1
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  recruitmentResponseModel.limit.toString(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: STUDY_PERSON_COLOR,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  "명 남음",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "제한없음",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: CLOUD_COLOR,
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
                  _formatText(recruitmentResponseModel.title, 40),
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatText(recruitmentResponseModel.content, 80),
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    recruitmentResponseModel.isOngoing
                        ? const Text(
                            "항시진행",
                            style: TextStyle(
                              fontSize: 10,
                              color: CLOUD_COLOR,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : Text(
                            date,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      hashTags,
                      style: const TextStyle(
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
