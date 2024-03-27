import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/layout/text_with_icon.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/board/provider/board_add_provider.dart';
import 'package:frontend/board/provider/board_state_notifier_provider.dart';
import 'package:frontend/board/provider/image_provider.dart';
import 'package:frontend/board/provider/isquestion_provider.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

class MsgBoardAddScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  const MsgBoardAddScreen({super.key, required this.isEdit});

  @override
  ConsumerState<MsgBoardAddScreen> createState() => _MsgBoardAddScreenState();
}

class _MsgBoardAddScreenState extends ConsumerState<MsgBoardAddScreen> {
  late BoardAdd boardAddAPI;
  bool canUpload = false;
  bool writedTitle = false;
  bool writedContent = false;
  String selectCategory = "자유게시판";
  String title = "", content = "";
  bool isQuestion = false;
  List<XFile> realImages = [];

  @override
  void initState() {
    super.initState();
  }

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
            onPressed: () {
              if (canUpload) {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("'$selectCategory'에 글을 등록할까요?"),
                          ],
                        ),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    List<String> images = [];
                                    for (int i = 0;
                                        i < realImages.length;
                                        i++) {
                                      images.add("image$i.jpg");
                                    }
                                    final requestData = {
                                      'communityTitle':
                                          categoryCodesList[selectCategory],
                                      'title': title,
                                      'content': content,
                                      'isQuestion': isQuestion,
                                      'images': images,
                                    };
                                    MsgBoardResponseModel resp =
                                        await boardAddAPI.post(requestData);
                                    // TODO : resp의 image 링크에 image들 올려야 함
                                    for (int i = 0;
                                        i < resp.images.length;
                                        i++) {
                                      final String url = resp.images[i];
                                      UploadFile()
                                          .call(url, File(realImages[i].path));
                                    }
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    ref
                                        .read(
                                            boardStateNotifierProvider.notifier)
                                        .paginate(forceRefetch: true);
                                  },
                                  child: const Text("네"),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("아니요"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }));
              }
            },
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
                              title = value; // 제목
                              writedTitle = true;
                              canUpload = writedTitle & writedContent;
                            }
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "제목",
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: BODY_TEXT_COLOR.withOpacity(0.5)))),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: DropdownButton(
                            value: selectCategory,
                            icon: const Icon(Icons.arrow_drop_down_outlined),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                            underline: Container(),
                            elevation: 0,
                            dropdownColor: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                            items: categorysList
                                .sublist(1, categorysList.length)
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) => {
                              setState(() {
                                if (value != null) {
                                  selectCategory = value; // 게시판 종류
                                }
                              })
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: PRIMARY20_COLOR,
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
                        content = value; // 내용
                        writedContent = true;
                        canUpload = writedTitle & writedContent;
                      }
                    });
                  },
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                  decoration: const InputDecoration(
                    hintText: "지금 가장 고민이 되거나 궁금한 내용이 무엇인가요?",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomView(
            widget: widget,
            msgBoardAddScreenState: this,
          )
        ],
      ),
    );
  }
}

class BottomView extends ConsumerWidget {
  const BottomView(
      {super.key, required this.widget, required this.msgBoardAddScreenState});

  final MsgBoardAddScreen widget;
  final _MsgBoardAddScreenState msgBoardAddScreenState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    msgBoardAddScreenState.boardAddAPI = ref.watch(boardAddProvider);
    msgBoardAddScreenState.isQuestion = ref.watch(isQuestionStateProvider);
    return Column(
      children: [
        ImageViewer(
          msgBoardAddScreenState: msgBoardAddScreenState,
        ),
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
                    commentId: -1,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextWithIcon(
                    icon: Icons.check_box_outline_blank_rounded,
                    iconSize: 17,
                    text: "질문",
                    commentId: -1,
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
  const ImageViewer({super.key, required this.msgBoardAddScreenState});
  final _MsgBoardAddScreenState msgBoardAddScreenState;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<XFile> images = ref.watch(imageStateProvider);
    msgBoardAddScreenState.realImages = images;
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

class UploadFile {
  Future<void> call(String url, File image) async {
    try {
      var response =
          await http.put(Uri.parse(url), body: image.readAsBytesSync());
      if (response.statusCode != 200) {
        debugPrint("upload file 응답 : ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("upload file 에러 : $e");
    }
  }
}
