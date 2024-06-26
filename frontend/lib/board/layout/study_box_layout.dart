import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/common/const/fonts.dart';

class StudyBox extends ConsumerStatefulWidget {
  const StudyBox({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyBox();
}

class _StudyBox extends ConsumerState<StudyBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115,
      decoration: BoxDecoration(
        color: BOARD_CARD_COLOR,
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
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "2",
                    style: TextStyle(
                      fontSize: 10,
                      color: STUDY_PERSON_COLOR,
                      fontFamily: MyFontFamily.GmarketSansBold,
                    ),
                  ),
                  Text(
                    "명 남음",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontFamily: MyFontFamily.GmarketSansBold,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "빅데이터 통계 시각화 아이디어 경진대회 참여자 모집합니다~!",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontFamily: MyFontFamily.GmarketSansBold,
                      height: 1,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  SizedBox(
                    height: 19,
                  ),
                  Text(
                    "2024.06.17~08.02",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontFamily: MyFontFamily.GmarketSansMedium,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "#통계학 #경진대회",
                    style: TextStyle(
                      fontSize: 10,
                      color: TAG_COLOR,
                      fontFamily: MyFontFamily.GmarketSansMedium,
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
