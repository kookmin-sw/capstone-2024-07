import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/provider/board_add_provider.dart';
import 'package:frontend/board/provider/comment_provider.dart';
import 'package:frontend/board/provider/isquestion_provider.dart';
import 'package:frontend/board/provider/image_provider.dart';
import 'package:frontend/board/provider/comment_notifier_provider.dart';
import 'package:frontend/board/provider/reply_notifier_provider.dart';
import 'package:frontend/board/provider/reply_provider.dart';
import 'package:frontend/board/provider/scrap_provider.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:image_picker/image_picker.dart';

class TextWithIcon extends ConsumerStatefulWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  final int commentId;
  final int postId;
  final int replyId;
  final bool isClicked;
  final bool isMine;

  const TextWithIcon({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.text,
    required this.commentId,
    required this.postId,
    required this.replyId,
    required this.isClicked,
    required this.isMine,
  });

  @override
  ConsumerState<TextWithIcon> createState() => _TextWithIconState();
}

class _TextWithIconState extends ConsumerState<TextWithIcon>
    with SingleTickerProviderStateMixin {
  bool isHeartClicked = false;
  bool isFavoriteClicked = false;
  bool isQuestionClicked = false;
  bool cantClicked = true;
  // ignore: prefer_typing_uninitialized_variables
  var textCount;

  late AnimationController heartAnimationController;
  final ImagePicker picker = ImagePicker();

  Future<String> getImage() async {
    List<XFile> images = [];
    try {
      images = await picker.pickMultiImage();
    } catch (e) {
      debugPrint("getImageError : $e");
      return e.toString(); // permission access need!
    }
    ref.read(imageStateProvider.notifier).add(images);
    return "";
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

  void increaseHeart() {
    setState(() {
      textCount += 1;
      isHeartClicked = true;
    });
    heartAnimationController.forward();
  }

  @override
  void initState() {
    super.initState();
    if (widget.icon == Icons.favorite_outline_rounded) {
      isHeartClicked = widget.isClicked;
    } else if (widget.icon == Icons.star_outline_rounded) {
      isFavoriteClicked = widget.isClicked;
    } else if (widget.icon == Icons.check_box_outline_blank_rounded) {
      isQuestionClicked = widget.isClicked;
      cantClicked = isQuestionClicked;
    }
    textCount = int.tryParse(widget.text);
    textCount ??= widget.text;
    heartAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HeartAnim(
          heartAnimationController: heartAnimationController,
          isHeartClicked: isHeartClicked,
          widget: widget,
          s: 0.2,
          e: -1.5,
        ),
        HeartAnim(
          heartAnimationController: heartAnimationController,
          isHeartClicked: isHeartClicked,
          widget: widget,
          s: -0.2,
          e: -1.0,
        ),
        HeartAnim(
          heartAnimationController: heartAnimationController,
          isHeartClicked: isHeartClicked,
          widget: widget,
          s: 0.3,
          e: -1.2,
        ),
        GestureDetector(
          onTap: () {
            if (widget.icon == Icons.favorite_outline_rounded) {
              if (isHeartClicked) {
                alreadyHeart(context);
              } else {
                if (widget.postId != -1) {
                  if (widget.isMine) {
                    notAllowed("자신의 글에는 좋아요를 할 수 없습니다.");
                  } else {
                    try {
                      ref.watch(boardAddProvider).heart(widget.postId);
                      increaseHeart();
                    } on DioException catch (e) {
                      notAllowed(e.message!);
                    }
                  }
                } else if (widget.commentId != -1) {
                  if (widget.commentId == -3) {
                    notAllowed("이미 삭제된 댓글입니다.");
                  } else if (widget.isMine) {
                    notAllowed("자신의 댓글에는 좋아요를 할 수 없습니다.");
                  } else {
                    final requestData = {
                      'commentId': widget.commentId,
                    };
                    try {
                      ref.watch(commentProvider).heart(requestData);
                      increaseHeart();
                    } on DioException catch (e) {
                      notAllowed(e.message!);
                    }
                  }
                } else if (widget.replyId != -1) {
                  if (widget.isMine) {
                    notAllowed("자신의 대댓글에는 좋아요를 할 수 없습니다.");
                  } else {
                    final requestData = {
                      'replyId': widget.replyId,
                    };
                    try {
                      ref.watch(replyProvider).heart(requestData);
                      increaseHeart();
                    } on DioException catch (e) {
                      notAllowed(e.message!);
                    }
                  }
                }
              }
            } else if (widget.icon == Icons.chat_outlined &&
                widget.commentId != -1) {
              if (widget.commentId == -2) {
                notAllowed("삭제된 댓글엔 대댓글을 달 수 없습니다.");
              } else {
                chatDialog(context);
              }
            } else if (widget.icon == Icons.star_outline_rounded) {
              setState(() {
                if (isFavoriteClicked) {
                  textCount -= 1;
                  ref.watch(scrapProvider).delete(widget.postId);
                } else {
                  textCount += 1;
                  ref.watch(scrapProvider).post(widget.postId);
                }
                isFavoriteClicked = !isFavoriteClicked;
              });
            } else if (widget.icon == Icons.image_rounded) {
              getImage().then((value) => {
                    if (value != "")
                      {
                        showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "사진 접근 허용을 해주세요!\n$value",
                                      textAlign: TextAlign.center,
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
                                        child: const Text("확인"),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }))
                      }
                  });
            } else if (widget.icon == Icons.check_box_outline_blank_rounded &&
                !cantClicked) {
              setState(() {
                isQuestionClicked = !isQuestionClicked;
              });
              ref.read(isQuestionStateProvider.notifier).set(isQuestionClicked);
            } else if (widget.icon == Icons.more_horiz) {
              if (widget.commentId == -3) {
                notAllowed("이미 삭제된 댓글입니다.");
              } else if (widget.commentId == -2) {
                notAllowed("댓글 수정 권한이 없습니다.");
              } else if (widget.replyId == -2) {
                notAllowed("대댓글 수정 권한이 없습니다.");
              } else {
                moreDialog(context);
              }
            }
          },
          child: Row(
            children: [
              Icon(
                isHeartClicked
                    ? Icons.favorite
                    : isQuestionClicked
                        ? Icons.check_box_rounded
                        : isFavoriteClicked
                            ? Icons.star
                            : widget.icon,
                size: widget.iconSize,
                color: isHeartClicked
                    ? Colors.red
                    : isQuestionClicked
                        ? Colors.blue.withOpacity(0.5)
                        : isFavoriteClicked
                            ? Colors.yellow
                            : null,
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                textCount == -1 ? "" : "$textCount",
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<dynamic> alreadyHeart(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("이미 좋아요를 눌렀습니다."),
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
                    child: const Text("확인"),
                  ),
                ],
              ),
            ],
          );
        }));
  }

  Future<dynamic> chatDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("이 댓글에 대댓글을 달까요?"),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(commentStateProvider.notifier)
                          .add(0, widget.commentId);
                      Navigator.of(context).pop();
                    },
                    child: const Text("네"),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("아니요"),
                  ),
                ],
              ),
            ],
          );
        }));
  }

  Future<dynamic> moreDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.zero,
            backgroundColor: PRIMARY10_COLOR,
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () {
                            select(2);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "삭제하기",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
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
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () {
                            select(1);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "수정하기",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        }));
  }

  void select(int code) {
    if (widget.commentId != -1) {
      ref.read(commentStateProvider.notifier).add(code, widget.commentId);
    } else if (widget.replyId != -1) {
      ref.read(replyStateProvider.notifier).add(code, widget.replyId);
    }
  }
}

class HeartAnim extends StatelessWidget {
  const HeartAnim({
    super.key,
    required this.heartAnimationController,
    required this.isHeartClicked,
    required this.widget,
    required this.s,
    required this.e,
  });

  final AnimationController heartAnimationController;
  final bool isHeartClicked;
  final TextWithIcon widget;
  final double s, e;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 3.0, end: 0.0).animate(CurvedAnimation(
          parent: heartAnimationController,
          curve: Curves.fastLinearToSlowEaseIn)),
      child: SlideTransition(
        position:
            Tween<Offset>(begin: const Offset(0.0, 0.0), end: Offset(s, e))
                .animate(CurvedAnimation(
                    parent: heartAnimationController,
                    curve: Curves.fastLinearToSlowEaseIn)),
        child: isHeartClicked
            ? Icon(
                isHeartClicked ? Icons.favorite : widget.icon,
                size: widget.iconSize,
                color: isHeartClicked ? Colors.red : null,
              )
            : null,
      ),
    );
  }
}
