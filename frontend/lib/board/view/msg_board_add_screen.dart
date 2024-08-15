import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/layout/text_with_icon.dart';
import 'package:frontend/board/model/exception_model.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/board/model/recruitment_response_model.dart';
import 'package:frontend/board/provider/board_add_provider.dart';
import 'package:frontend/board/provider/board_state_notifier_provider.dart';
import 'package:frontend/board/provider/image_provider.dart';
import 'package:frontend/board/provider/anonymous_provider.dart';
import 'package:frontend/board/provider/network_image_provider.dart';
import 'package:frontend/board/provider/recruitment_add_provider.dart';
import 'package:frontend/board/provider/recruitment_state_notifier_provider.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/member/provider/mypage/my_post_state_notifier_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crypto/crypto.dart';

import 'package:http/http.dart' as http;

class MsgBoardAddScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  final bool isRecruitment;
  final MsgBoardResponseModel? board;
  final RecruitmentResponseModel? recruitmentBoard;
  const MsgBoardAddScreen(
      {super.key,
      required this.isEdit,
      required this.isRecruitment,
      required this.board,
      required this.recruitmentBoard});

  @override
  ConsumerState<MsgBoardAddScreen> createState() => _MsgBoardAddScreenState();
}

class _MsgBoardAddScreenState extends ConsumerState<MsgBoardAddScreen> {
  late BoardAdd boardAddAPI;
  bool canUpload = false;
  bool writedTitle = false;
  bool writedContent = false;
  String selectCategory = "자유";
  String title = "", content = "";
  bool isAnonymous = false;
  List<XFile> realImages = [];
  List<String> networkImages = [];
  late TextEditingController titleController;
  late TextEditingController contentController;
  bool isLoading = false;

  bool isOffline = false;
  bool isAlways = false;
  bool isNotLimit = false;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  double width = 0, height = 0;

  @override
  void initState() {
    super.initState();

    int limit = -2;

    if (widget.isEdit) {
      if (widget.isRecruitment) {
        selectCategory =
            categoryCodesReverseList2[widget.recruitmentBoard!.type].toString();
        title = widget.recruitmentBoard!.title;
        content = widget.recruitmentBoard!.content;

        isOnline = widget.recruitmentBoard!.isOnline;
        isAlways = widget.recruitmentBoard!.isOngoing;
        isNotLimit = widget.recruitmentBoard!.limit == -1;
        startDate = widget.recruitmentBoard!.startDateTime;
        endDate = widget.recruitmentBoard!.endDateTime;
        limit = widget.recruitmentBoard!.limit;

        canUpload = writedTitle = writedContent = true;
      } else {
        selectCategory =
            categoryCodesReverseList[widget.board!.communityTitle].toString();
        title = widget.board!.postTitle;
        content = widget.board!.postContent;
        isAnonymous = widget.board!.isAnonymous;

        canUpload = writedTitle = writedContent = true;
      }
    }

    titleController = TextEditingController(text: title);
    contentController = TextEditingController(text: content);
    if (limit == -2) {
      recruitmentPersonController = TextEditingController();
    } else {
      recruitmentPersonController =
          TextEditingController(text: limit.toString());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    debugPrint("크기 : $width $height");
  }

  void refresh() async {
    ref.read(boardStateNotifierProvider.notifier).lastId = 9223372036854775807;
    await ref
        .read(boardStateNotifierProvider.notifier)
        .paginate(forceRefetch: true);
    ref.read(myPostStateNotifierProvider.notifier).lastId = 9223372036854775807;
    await ref
        .read(myPostStateNotifierProvider.notifier)
        .paginate(forceRefetch: true);
    ref.read(recruitmentStateNotifierProvider.notifier).lastId =
        9223372036854775807;
    await ref
        .read(recruitmentStateNotifierProvider.notifier)
        .paginate(forceRefetch: true);
  }

  void notAllowed(String s) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    s,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
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
                      style: TextStyle(
                        fontSize: 13,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }));
  }

  void filterDialog(String s) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    s,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
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

                      upLoad();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: PRIMARY50_COLOR,
                    ),
                    child: const Text(
                      "네",
                      style: TextStyle(
                        fontSize: 13,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: PRIMARY50_COLOR,
                    ),
                    child: const Text(
                      "아니요",
                      style: TextStyle(
                        fontSize: 13,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }));
  }

  String getRandomStr() {
    String dt = DateTime.now().toString();
    final bytes = utf8.encode(dt);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<void> upLoad() async {
    isAnonymous = ref.watch(isAnonymousStateProvider);

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

    if (images.length > 10) {
      notAllowed("사진은 최대 10개까지만 가능합니다.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (widget.isEdit) {
      final requestData = {
        'communityTitle': categoryCodesList[selectCategory],
        'postId': widget.board!.id,
        'title': title,
        'content': content,
        'isAnonymous': isAnonymous,
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
          Map<String, dynamic> data = e.response!.data;
          ExceptionModel exc = ExceptionModel.fromJson(data);
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
        'isAnonymous': isAnonymous,
        'images': images,
      };
      MsgBoardResponseModel resp;
      try {
        resp = await boardAddAPI.post(requestData);
      } on DioException catch (e) {
        if (e.response != null) {
          Map<String, dynamic> data = e.response!.data;
          ExceptionModel exc = ExceptionModel.fromJson(data);
          debugPrint("boardPostError : ${exc.message}");
          notAllowed(exc.message);
          return;
        } else {
          debugPrint("boardPostError : ${e.message}");
          notAllowed(e.message!);
          return;
        }
      } catch (e) {
        debugPrint("boardPostError : ${e.toString()}");
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

    refresh();

    ref.read(imageStateProvider.notifier).clear();
    ref.read(networkImageStateProvider.notifier).clear();
    ref.read(isAnonymousStateProvider.notifier).set(false);

    Navigator.of(context).pop();
  }

  String changeDateFormat(DateTime t) {
    String tS = t.toString();
    tS = tS.replaceAll(" ", "T");
    if (tS.length > 23) {
      tS = tS.replaceRange(23, 26, 'Z');
    } else {
      tS = '${tS}Z';
    }
    return tS;
  }

  Future<void> upLoadRecruitment() async {
    List<String> splitText = content.split("#");

    List<String> hashTags = splitText.sublist(1, splitText.length);

    if (widget.isEdit) {
      final requestData = {
        'recruitmentId': widget.recruitmentBoard?.id.toString(),
        'type': categoryCodesList2[selectCategory],
        'isOnline': isOnline,
        'isOngoing': isAlways,
        'limit': isNotLimit ? -1 : recruitmentPersonController.text,
        'startDateTime': changeDateFormat(startDate),
        'endDateTime': changeDateFormat(DateTime(endDate.year, endDate.month,
            endDate.day, 23, 59, 59, endDate.millisecond, endDate.microsecond)),
        'title': title,
        'content': content,
        'hashTags': hashTags,
        'recruitable': widget.recruitmentBoard?.recruitable,
      };

      try {
        await recruitmentAddAPI.modify(requestData);
      } on DioException catch (e) {
        if (e.response != null) {
          Map<String, dynamic> data = e.response!.data;
          ExceptionModel exc = ExceptionModel.fromJson(data);
          debugPrint("RecruitmentModifyError : ${exc.message}");
          notAllowed(exc.message);
          return;
        } else {
          debugPrint("RecruitmentModifyError : ${e.message}");
          notAllowed(e.message!);
          return;
        }
      } catch (e) {
        debugPrint("RecruitmentModifyError : ${e.toString()}");
        notAllowed("다시 시도해주세요!");
        return;
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      final requestData = {
        'type': categoryCodesList2[selectCategory],
        'isOnline': isOnline,
        'isOngoing': isAlways,
        'limit': isNotLimit ? -1 : recruitmentPersonController.text,
        'startDateTime': changeDateFormat(startDate),
        'endDateTime': changeDateFormat(DateTime(endDate.year, endDate.month,
            endDate.day, 23, 59, 59, endDate.millisecond, endDate.microsecond)),
        'title': title,
        'content': content,
        'hashTags': hashTags,
        'isAnonymous': isAnonymous,
      };

      try {
        await recruitmentAddAPI.post(requestData);
      } on DioException catch (e) {
        if (e.response != null) {
          Map<String, dynamic> data = e.response!.data;
          ExceptionModel exc = ExceptionModel.fromJson(data);
          debugPrint("RecruitmentPostError : ${exc.message}");
          notAllowed(exc.message);
          return;
        } else {
          debugPrint("RecruitmentPostError : ${e.message}");
          notAllowed(e.message!);
          return;
        }
      } catch (e) {
        debugPrint("RecruitmentPostError : ${e.toString()}");
        notAllowed("다시 시도해주세요!");
        return;
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }

    refresh();

    ref.read(isAnonymousStateProvider.notifier).set(false);

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
                      ? Text(
                          "'$selectCategory'에 글을 수정할까요?",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : Text(
                          "'$selectCategory'에 글을 등록할까요?",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
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
                        setState(() {
                          isLoading = true;
                        });
                        upLoad();
                      },
                      child: const Text(
                        "네",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "아니요",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
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
      GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
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
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: [
              TextButton(
                onPressed: upLoadDialog,
                child: Text(
                  "완료",
                  style: TextStyle(
                    color: canUpload ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          body: Stack(children: [
            Transform.translate(
              offset: Offset(80.0, height / 2),
              child: Image.asset(
                'asset/imgs/logo.png',
                width: 450.0,
                opacity: const AlwaysStoppedAnimation(.2),
              ),
            ),
            Column(
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
                                  } else {
                                    writedTitle = false;
                                  }
                                  canUpload = writedTitle & writedContent;
                                });
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "제목",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: BOX_LINE_COLOR,
                                  ),
                                ),
                              ),
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
                                padding:
                                    const EdgeInsets.only(left: 15, right: 10),
                                child: DropdownButton(
                                  value: selectCategory,
                                  icon: const Icon(
                                    Icons.arrow_drop_down_outlined,
                                    color: Colors.black,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  underline: Container(),
                                  elevation: 0,
                                  dropdownColor: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                  items: categorysList2
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                      ),
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
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: BOX_LINE_COLOR,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      selectCategory == "스터디" || selectCategory == "프로젝트"
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: MAJOR_SELECT_COLOR,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.white,
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 7.0,
                                                    vertical: 4.0,
                                                  ),
                                                  child: Text(
                                                    "진행기간",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                )),
                                            SizedBox(
                                              width: width < 380 ? 11 : 18,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                final selectedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: startDate,
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(2100),
                                                );
                                                if (selectedDate != null) {
                                                  setState(() {
                                                    startDate = selectedDate;
                                                    if (endDate
                                                        .isBefore(startDate)) {
                                                      endDate = selectedDate;
                                                    }
                                                  });
                                                }
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.white,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 7.0,
                                                      vertical: 4.0,
                                                    ),
                                                    child: Text(
                                                      "${startDate.year.toString()}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            const Text(
                                              "~",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                final selectedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: endDate,
                                                  firstDate: startDate,
                                                  lastDate: DateTime(2100),
                                                );
                                                if (selectedDate != null) {
                                                  setState(() {
                                                    endDate = selectedDate;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.white,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 7.0,
                                                      vertical: 4.0,
                                                    ),
                                                    child: Text(
                                                      "${endDate.year.toString()}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isAlways = !isAlways;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 3),
                                        child: Row(
                                          children: [
                                            Icon(
                                              isAlways
                                                  ? Icons.check_box_rounded
                                                  : Icons
                                                      .check_box_outline_blank_rounded,
                                              size: 20,
                                              color: isAlways
                                                  ? ACTIVE_COLOR
                                                  : null,
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            const Text(
                                              "항시진행",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FlutterSwitch(
                                        showOnOff: true,
                                        inactiveText: "오프라인",
                                        activeText: "온라인",
                                        activeTextColor: Colors.white,
                                        inactiveTextColor: Colors.white,
                                        valueFontSize: 14,
                                        activeTextFontWeight: FontWeight.w400,
                                        inactiveTextFontWeight: FontWeight.w400,
                                        width: 110.0,
                                        height: 28.0,
                                        inactiveColor: INACTIVE_COLOR,
                                        value: isOffline,
                                        activeColor: ACTIVE_COLOR,
                                        onToggle: (bool? value) {
                                          setState(() {
                                            isOffline = value ?? false;
                                          });
                                        }),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: MAJOR_SELECT_COLOR,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 7.0,
                                                  vertical: 4.0,
                                                ),
                                                child: Text(
                                                  "모집인원",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 18,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              width: 20,
                                              height: 20,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3.0, bottom: 8.0),
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10,
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  maxLength: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: "0",
                                                    counterText: "",
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Text(
                                              "명",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isNotLimit = !isNotLimit;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 3),
                                        child: Row(
                                          children: [
                                            Icon(
                                              isNotLimit
                                                  ? Icons.check_box_rounded
                                                  : Icons
                                                      .check_box_outline_blank_rounded,
                                              size: 20,
                                              color: isNotLimit
                                                  ? ACTIVE_COLOR
                                                  : null,
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            const Text(
                                              "제한없음",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: BOX_LINE_COLOR,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                          : const SizedBox(
                              height: 10,
                            ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: PRIMARY20_COLOR,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "잠깐!",
                              style: TextStyle(
                                fontSize: width < 380 ? 9 : 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                "부적절하거나 불쾌감을 줄 수 있는 컨텐츠는 제재를 받을 수 있습니다.",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontSize: width < 380 ? 9 : 10,
                                  fontWeight: FontWeight.w400,
                                ),
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
                            } else {
                              writedContent = false;
                            }
                            canUpload = writedTitle & writedContent;
                          });
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: height < 700 ? 7 : 14,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: selectCategory == "스터디" ||
                                  selectCategory == "프로젝트"
                              ? "구체적인 스터디 모임 내용을 자세하게 적으면,\n인원 모집에 도움이 됩니다.\n\n#해시태그 를 달아 모집글을 더 노출시켜보세요!"
                              : "지금 가장 고민이 되거나 궁금한 내용이 무엇인가요?",
                          border: InputBorder.none,
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
          ]),
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
    return Column(
      children: [
        if (!(widget.isRecruitment))
          ImageViewer(
            msgBoardAddScreenState: msgBoardAddScreenState,
          ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: BOX_LINE_COLOR,
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
                    postId: -1,
                    replyId: -1,
                    isClicked: false,
                    isMine: false,
                    userId: -1,
                  ),
                  TextWithIcon(
                    icon: Icons.check_box_outline_blank_rounded,
                    iconSize: 17,
                    text: "익명",
                    commentId: -1,
                    postId: -1,
                    replyId: -1,
                    isClicked: false,
                    isMine: false,
                    userId: -1,
                  ),
                ],
              ),
              if (widget.isEdit)
                TextButton(
                  onPressed: () async {
                    if (widget.isRecruitment) {
                      await ref
                          .watch(recruitmentAddProvider)
                          .delete(widget.recruitmentBoard!.id);
                    } else {
                      await ref
                          .watch(boardAddProvider)
                          .delete(widget.board!.id);
                    }
                    ref.read(boardStateNotifierProvider.notifier).lastId =
                        9223372036854775807;
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
                      fontWeight: FontWeight.w400,
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
          msgBoardAddScreenState.widget.board!.images;
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
                          color: const Color.fromARGB(255, 214, 214, 214),
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
                          color: const Color.fromARGB(255, 214, 214, 214),
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
                          color: const Color.fromARGB(255, 214, 214, 214),
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
