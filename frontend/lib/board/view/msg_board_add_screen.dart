import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/layout/text_with_icon.dart';
import 'package:frontend/board/model/exception_model.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/board/provider/board_add_provider.dart';
import 'package:frontend/board/provider/board_state_notifier_provider.dart';
import 'package:frontend/board/provider/image_provider.dart';
import 'package:frontend/board/provider/isquestion_provider.dart';
import 'package:frontend/board/provider/network_image_provider.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

import '../../common/const/ip_list.dart';

class MsgBoardAddScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  final MsgBoardResponseModel board;
  const MsgBoardAddScreen(
      {super.key, required this.isEdit, required this.board});

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
  List<String> networkImages = [];
  late TextEditingController titleController;
  late TextEditingController contentController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      selectCategory =
          categoryCodesReverseList[widget.board.communityTitle].toString();
      title = widget.board.postTitle;
      content = widget.board.postContent;
      isQuestion = widget.board.isQuestion;
      canUpload = widget.isEdit;

      canUpload = writedTitle = writedContent = true;
    }

    titleController = TextEditingController(text: title);
    contentController = TextEditingController(text: content);
  }

  void notAllowed(String s) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  s,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: PRIMARY50_COLOR,
                    ),
                    child: const Text(
                      "확인",
                      style: TextStyle(fontSize: 13, color: PRIMARY_COLOR),
                    ),
                  ),
                ],
              ),
            ],
          );
        }));
  }

  String getRandomStr() {
    var random = Random();
    var leastCharacterIndex = [];
    var skipCharacter = [0x2B, 0x2D, 0x20];
    var min = 0x21;
    var max = 0x7A;
    var dat = [];
    while (dat.length <= 32) {
      var tmp = min + random.nextInt(max - min);
      if (skipCharacter.contains(tmp)) {
        continue;
      }

      dat.add(tmp);
    }

    while (leastCharacterIndex.length < 2) {
      var ran = random.nextInt(32);
      if (!leastCharacterIndex.contains(ran)) {
        leastCharacterIndex.add(ran);
      }
    }

    dat[leastCharacterIndex[0]] = 0x25;
    dat[leastCharacterIndex[1]] = 0x40;
    return String.fromCharCodes(dat.cast<int>());
  }

  Future<void> upLoad() async {
    var dio = Dio();
    try {
      Response titleCheck =
          await dio.post('$pythonIP/predict/', data: {"message": title});
      debugPrint("titleCheck : ${titleCheck.data["profanity"]}");
      if (titleCheck.data["profanity"]) {
        notAllowed("제목에 비속어가 포함되어 있습니다.\n수정 후 다시 시도해주세요!");
        setState(() {
          isLoading = false;
        });
        return;
      }
    } catch (e) {
      debugPrint("upload_title_predict : ${e.toString()}");
    }

    try {
      Response contentCheck =
          await dio.post('$pythonIP/predict/', data: {"message": content});
      debugPrint("titleCheck : ${contentCheck.data["profanity"]}");
      if (contentCheck.data["profanity"]) {
        notAllowed("글 내용에 비속어가 포함되어 있습니다.\n수정 후 다시 시도해주세요!");
        setState(() {
          isLoading = false;
        });
        return;
      }
    } catch (e) {
      debugPrint("upload_content_predict : ${e.toString()}");
    }

    List<String> images = [];
    int i = 0;
    for (; i < networkImages.length; i++) {
      // network image URL
      if (networkImages[i].contains("jpg")) {
        images.add("${getRandomStr()}$i.jpg");
      } else if (networkImages[i].contains("png")) {
        images.add("${getRandomStr()}$i.png");
      } else if (networkImages[i].contains("jpeg")) {
        images.add("${getRandomStr()}$i.jpeg");
      } else if (networkImages[i].contains("gif")) {
        images.add("${getRandomStr()}$i.gif");
      } else if (networkImages[i].contains("HEIC")) {
        images.add("${getRandomStr()}$i.HEIC");
      }
    }
    for (; i - networkImages.length < realImages.length; i++) {
      // local image path
      if (realImages[i - networkImages.length].path.endsWith("jpg")) {
        images.add("${getRandomStr()}$i.jpg");
      } else if (realImages[i - networkImages.length].path.endsWith("png")) {
        images.add("${getRandomStr()}$i.png");
      } else if (realImages[i - networkImages.length].path.endsWith("jpeg")) {
        images.add("${getRandomStr()}$i.jpeg");
      } else if (realImages[i - networkImages.length].path.endsWith("gif")) {
        images.add("${getRandomStr()}$i.gif");
      } else if (realImages[i - networkImages.length].path.endsWith("HEIC")) {
        images.add("${getRandomStr()}$i.HEIC");
      }
    }
    if (widget.isEdit) {
      final requestData = {
        'postId': widget.board.id,
        'title': title,
        'content': content,
        'images': images,
      };
      List<http.Response> httpImages = [];
      for (int i = 0; i < networkImages.length; i++) {
        httpImages.add(await http.get(Uri.parse(networkImages[i])));
      }
      MsgBoardResponseModel resp;
      try {
        resp = await boardAddAPI.modify(requestData);
      } on DioException catch (e) {
        if (e.response != null) {
          ExceptionModel exc = e.response!.data;
          debugPrint("boardModifyError : ${exc.message}");
          notAllowed(exc.message);
        } else {
          debugPrint("boardModifyError : ${e.message}");
          notAllowed(e.message!);
        }
        return;
      } catch (e) {
        debugPrint("boardModifyError : $e");
        notAllowed("다시 시도해주세요!");
        return;
      } finally {
        setState(() {
          isLoading = false;
        });
      }

      i = 0;
      for (; i < resp.images.length; i++) {
        final String url = resp.images[i];
        if (i < networkImages.length) {
          UploadFile().httpFile(url, httpImages[i]);
        } else {
          if (i == resp.images.length - 1) {
            // 마지막 사진만 업로드가 다 될때까지 기다림
            await UploadFile()
                .file(url, File(realImages[i - networkImages.length].path));
          } else {
            UploadFile()
                .file(url, File(realImages[i - networkImages.length].path));
          }
        }
      }
    } else {
      final requestData = {
        'communityTitle': categoryCodesList[selectCategory],
        'title': title,
        'content': content,
        'isQuestion': isQuestion,
        'images': images,
      };
      MsgBoardResponseModel resp;
      try {
        resp = await boardAddAPI.post(requestData);
      } on DioException catch (e) {
        if (e.response != null) {
          ExceptionModel exc = e.response!.data;
          debugPrint("boardPostError : ${exc.message}");
          notAllowed(exc.message);
          return;
        } else {
          debugPrint("boardModifyError : ${e.message}");
          notAllowed(e.message!);
          return;
        }
      } catch (e) {
        debugPrint("boardModifyError : ${e.toString()}");
        notAllowed("다시 시도해주세요!");
        return;
      } finally {
        setState(() {
          isLoading = false;
        });
      }

      for (int i = 0; i < resp.images.length; i++) {
        final String url = resp.images[i];
        if (i == resp.images.length - 1) {
          await UploadFile().file(url, File(realImages[i].path));
        } else {
          UploadFile().file(url, File(realImages[i].path));
        }
      }
    }

    await ref
        .read(boardStateNotifierProvider.notifier)
        .paginate(forceRefetch: true);

    ref.read(imageStateProvider.notifier).clear();
    ref.read(networkImageStateProvider.notifier).clear();

    Navigator.of(context).pop();
  }

  void upLoadDialog() {
    if (canUpload) {
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.isEdit
                      ? Text("'$selectCategory'에 글을 수정할까요?")
                      : Text("'$selectCategory'에 글을 등록할까요?"),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          upLoad();
                          setState(() {
                            isLoading = true;
                          });
                          Navigator.of(context).pop();
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
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: PRIMARY10_COLOR,
          shadowColor: Colors.black,
          elevation: 3,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            widget.isEdit ? "글 수정" : "글 작성",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: upLoadDialog,
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
                          controller: titleController,
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
                                      color:
                                          BODY_TEXT_COLOR.withOpacity(0.5)))),
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
                                  .sublist(2, categorysList.length)
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
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
                    controller: contentController,
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
                      fontSize: 12,
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
            ),
          ],
        ),
      ),
      isLoading
          ? Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : const Center(),
    ]);
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
    if (!msgBoardAddScreenState.widget.isEdit) {
      msgBoardAddScreenState.isQuestion = ref.watch(isQuestionStateProvider);
    }
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
              Row(
                children: [
                  const TextWithIcon(
                    icon: Icons.image_rounded,
                    iconSize: 17,
                    text: "사진",
                    commentId: -1,
                    postId: -1,
                    replyId: -1,
                    isClicked: false,
                    isMine: false,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextWithIcon(
                    icon: Icons.check_box_outline_blank_rounded,
                    iconSize: 17,
                    text: "질문",
                    commentId: -1,
                    postId: -1,
                    replyId: -1,
                    isClicked: msgBoardAddScreenState.isQuestion,
                    isMine: false,
                  ),
                ],
              ),
              if (widget.isEdit)
                TextButton(
                  onPressed: () async {
                    await ref.watch(boardAddProvider).delete(widget.board.id);
                    await ref
                        .read(boardStateNotifierProvider.notifier)
                        .paginate(forceRefetch: true);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
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
    List<XFile> images;
    images = ref.watch(imageStateProvider);
    msgBoardAddScreenState.realImages = images;
    if (msgBoardAddScreenState.widget.isEdit) {
      msgBoardAddScreenState.networkImages =
          msgBoardAddScreenState.widget.board.images;
      for (var removeImg in ref.watch(networkImageStateProvider)) {
        msgBoardAddScreenState.networkImages.remove(removeImg);
      }
      try {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var image in msgBoardAddScreenState.networkImages)
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                          left: 10,
                          top: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black.withOpacity(0.2),
                        ),
                        width: 100,
                        child: Image(
                          image: NetworkImage(image),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(networkImageStateProvider.notifier)
                              .add(image);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                for (var image in images)
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                          left: 10,
                          top: 10,
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
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(imageStateProvider.notifier).remove(image);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      } catch (e) {
        debugPrint(
            "ImageViewer error! ${msgBoardAddScreenState.networkImages[0]}");
        return const SizedBox(
          height: 100,
          width: 100,
        );
      }
    } else {
      try {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var image in images)
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                          left: 10,
                          top: 10,
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
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(imageStateProvider.notifier).remove(image);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      } catch (e) {
        debugPrint("ImageViewer error! ${images[0].path}");
        return const SizedBox(
          height: 100,
          width: 100,
        );
      }
    }
  }
}

class UploadFile {
  Future<void> file(String url, File image) async {
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

  Future<void> httpFile(String url, http.Response image) async {
    try {
      var response = await http.put(Uri.parse(url), body: image.bodyBytes);
      if (response.statusCode != 200) {
        debugPrint("Upload HTTP File 응답 : ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Upload HTTP File 에러 : $e");
    }
  }
}
