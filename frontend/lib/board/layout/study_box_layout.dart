import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/recruitment_response_model.dart';
import 'package:frontend/common/const/colors.dart';

class StudyBox extends ConsumerStatefulWidget {
  final RecruitmentResponseModel recruitmentResponseModel;

  const StudyBox({
    super.key,
    required this.recruitmentResponseModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyBox();
}

class _StudyBox extends ConsumerState<StudyBox> {
  @override
  void initState() {
    super.initState();
  }

  String getTwoWord(int t) {
    if (t < 10) {
      return "0$t";
    } else {
      return "$t";
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime start = widget.recruitmentResponseModel.startDateTime;
    DateTime end = widget.recruitmentResponseModel.endDateTime;

    String date = "";
    if (!widget.recruitmentResponseModel.isOngoing) {
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
    for (HashTagsModel h in widget.recruitmentResponseModel.hashTags) {
      if (hashTagsNum < 2) {
        hashTags += "#${h.name} ";
        hashTagsNum++;
      } else {
        break;
      }
    }

    return Container(
      width: 115,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: STUDY_PERSON_BACK_COLOR,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 4,
              ),
              child: widget.recruitmentResponseModel.limit != -1
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.recruitmentResponseModel.limit.toString(),
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
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.recruitmentResponseModel.title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  widget.recruitmentResponseModel.isOngoing
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
                    height: 12,
                  ),
                  Text(
                    hashTags,
                    style: const TextStyle(
                      fontSize: 10,
                      color: TAG_COLOR,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
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
