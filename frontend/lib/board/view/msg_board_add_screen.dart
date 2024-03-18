import 'package:flutter/material.dart';
import 'package:frontend/board/layout/text_with_icon.dart';
import 'package:frontend/common/const/colors.dart';

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
          Column(
            children: [
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
                    const Row(
                      children: [
                        TextWithIcon(
                            icon: Icons.image_rounded,
                            iconSize: 17,
                            text: "사진",
                            canTap: true),
                        SizedBox(
                          width: 10,
                        ),
                        TextWithIcon(
                            icon: Icons.check_box_outline_blank_rounded,
                            iconSize: 17,
                            text: "질문",
                            canTap: true),
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
          )
        ],
      ),
    );
  }
}
