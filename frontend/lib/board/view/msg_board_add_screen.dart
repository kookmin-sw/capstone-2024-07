import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/layout/text_with_icon.dart';
import 'package:frontend/board/provider/image_provider.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:image_picker/image_picker.dart';

class MsgBoardAddScreen extends StatefulWidget {
  final bool isEdit;
  const MsgBoardAddScreen({super.key, required this.isEdit});

  @override
  State<MsgBoardAddScreen> createState() => _MsgBoardAddScreenState();
}

class _MsgBoardAddScreenState extends State<MsgBoardAddScreen> {
  bool canUpload = false;
  bool writedTitle = false;
  bool writedContent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 3,
        title: const Text(
          "컴퓨터공학과 | 글 작성",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "완료",
              style: TextStyle(
                color: canUpload ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            if (value != "") {
                              writedTitle = true;
                              canUpload = writedTitle & writedContent;
                            }
                          });
                        },
                        decoration: InputDecoration(
                            hintText: "제목",
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: BODY_TEXT_COLOR.withOpacity(0.5)))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: PRIMARY_COLOR.withOpacity(0.2),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "잠깐!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "개인정보 노출이나 모욕적인 말이 있는지 확인해주세요.",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      if (value != "") {
                        writedContent = true;
                        canUpload = writedTitle & writedContent;
                      }
                    });
                  },
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                  decoration: const InputDecoration(
                    hintText: "지금 가장 고민이 되거나 궁금한 내용이 무엇인가요?",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomView(widget: widget)
        ],
      ),
    );
  }
}

class BottomView extends ConsumerWidget {
  const BottomView({
    super.key,
    required this.widget,
  });

  final MsgBoardAddScreen widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const ImageViewer(),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: BODY_TEXT_COLOR.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextWithIcon(
                    icon: Icons.image_rounded,
                    iconSize: 17,
                    text: "사진",
                    canTap: true,
                    ref: ref,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextWithIcon(
                    icon: Icons.check_box_outline_blank_rounded,
                    iconSize: 17,
                    text: "질문",
                    canTap: true,
                    ref: ref,
                  ),
                ],
              ),
              if (widget.isEdit)
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "삭제",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 80,
        ),
      ],
    );
  }
}

class ImageViewer extends ConsumerWidget {
  const ImageViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<XFile> images = ref.watch(imageStateProvider);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var image in images)
              Container(
                margin: const EdgeInsets.only(
                  right: 10,
                ),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.2),
                ),
                width: 100,
                child: Image.file(
                  File(image.path),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
