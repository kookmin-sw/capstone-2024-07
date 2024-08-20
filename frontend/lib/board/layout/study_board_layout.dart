import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/layout/big_button_layout.dart';
import 'package:frontend/board/model/recruitment_detail_response_model.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/layout/category_circle_layout.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StudyBoard extends ConsumerWidget {
  final RecruitmentDetailResponseModel recruitmentDetailResponseModel;
  final bool isMine;
  final double titleSize;

  const StudyBoard({
    super.key,
    required this.recruitmentDetailResponseModel,
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

  String getTwoWord(int t) {
    if (t < 10) {
      return "0$t";
    } else {
      return "$t";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime start = recruitmentDetailResponseModel.startDateTime;
    DateTime end = recruitmentDetailResponseModel.endDateTime;

    String date = "";
    if (!recruitmentDetailResponseModel.isOngoing) {
      if (start.year == end.year) {
        date =
            "${start.year}.${getTwoWord(start.month)}.${getTwoWord(start.day)}~${getTwoWord(end.month)}.${getTwoWord(end.day)}";
      } else {
        date =
            "${start.year % 100}.${getTwoWord(start.month)}.${getTwoWord(start.day)}~${end.year % 100}.${getTwoWord(end.month)}.${getTwoWord(end.day)}";
      }
    }

    String allText = recruitmentDetailResponseModel.content;
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
      } else if (t.startsWith('#')) {
        spans.add(
          TextSpan(
            text: '$t\n',
            style: const TextStyle(
              color: TAG_COLOR,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
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
                  category: categoryCodesReverseList2[
                          recruitmentDetailResponseModel.type]
                      .toString(),
                ),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            recruitmentDetailResponseModel.isOnline
                                ? "온라인"
                                : "오프라인",
                            style: const TextStyle(
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
                      child: recruitmentDetailResponseModel.limit != -1
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  recruitmentDetailResponseModel.limit
                                      .toString(),
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
            Text(
              recruitmentDetailResponseModel.title,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            recruitmentDetailResponseModel.isOngoing
                ? const Text(
                    "항시진행",
                    style: TextStyle(
                      fontSize: 10,
                      color: CLOUD_COLOR,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : Text(
                    "진행기간 | $date",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            RichText(
              softWrap: true,
              text: TextSpan(
                children: spans,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${changeTime(recruitmentDetailResponseModel.createdDateTime.toString())} | ${recruitmentDetailResponseModel.userNickname}",
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    BigButton(
                      icon: Icons.star_outline_rounded,
                      iconSize: 20,
                      text:
                          recruitmentDetailResponseModel.scrapCount.toString(),
                      postId: recruitmentDetailResponseModel.id,
                      isClicked: recruitmentDetailResponseModel.isScrapped,
                      isMine: isMine,
                      userId: recruitmentDetailResponseModel.userId,
                      isRecruitment: true,
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
