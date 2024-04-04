import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/provider/board_add_provider.dart';
import 'package:frontend/board/provider/comment_provider.dart';
import 'package:frontend/board/provider/isquestion_provider.dart';
import 'package:frontend/board/provider/image_provider.dart';
import 'package:frontend/board/provider/comment_notifier_provider.dart';
import 'package:frontend/board/provider/reply_notifier_provider.dart';
import 'package:frontend/board/provider/reply_provider.dart';
import 'package:image_picker/image_picker.dart';

class TextWithIcon extends ConsumerStatefulWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  final int commentId;
  final int postId;
  final int replyId;
  final bool isClicked;

  const TextWithIcon({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.text,
    required this.commentId,
    required this.postId,
    required this.replyId,
    required this.isClicked,
  });

  @override
  ConsumerState<TextWithIcon> createState() => _TextWithIconState();
}

class _TextWithIconState extends ConsumerState<TextWithIcon>
    with SingleTickerProviderStateMixin {
  // TODO : if user click heart(write comment, favorite), then change icon.
  bool isHeartClicked = false;
  bool isFavoriteClicked = false;
  bool isQuestionClicked = false;
  bool cantClicked = true;
  // ignore: prefer_typing_uninitialized_variables
  var textCount;

  late AnimationController heartAnimationController;
  final ImagePicker picker = ImagePicker();
  Future<bool> getImage() async {
    List<XFile> images = [];
    try {
      images = await picker.pickMultiImage();
    } catch (e) {
      return true; // permission access need!
    }
    ref.read(imageStateProvider.notifier).add(images);
    return false;
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
            setState(() {
              if (widget.icon == Icons.favorite_outline_rounded) {
                if (isHeartClicked) {
                  showDialog(
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
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("확인"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }));
                } else {
                  textCount += 1;
                  heartAnimationController.forward();
                  isHeartClicked = true;
                  // TODO: add heartCount to Server
                  if (widget.postId != -1) {
                    ref.watch(boardAddProvider).heart(widget.postId);
                  } else if (widget.commentId != -1) {
                    final requestData = {
                      'commentId': widget.commentId,
                    };
                    ref.watch(commentProvider).heart(requestData);
                  } else if (widget.replyId != -1) {
                    final requestData = {
                      'replyId': widget.replyId,
                    };
                    ref.watch(replyProvider).heart(requestData);
                  }
                }
              } else if (widget.icon == Icons.chat_outlined &&
                  widget.commentId != -1) {
                ref
                    .read(commentStateProvider.notifier)
                    .add(0, widget.commentId);
                showDialog(
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
                              Container(
                                child: ElevatedButton(
                                  onPressed: () {
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
                                    ref
                                        .read(commentStateProvider.notifier)
                                        .add(0, -1);
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
              } else if (widget.icon == Icons.star_outline_rounded) {
                if (isFavoriteClicked) {
                  textCount -= 1;
                } else {
                  textCount += 1;
                }
                isFavoriteClicked = !isFavoriteClicked;
              } else if (widget.icon == Icons.image_rounded) {
                getImage().then((value) => {
                      if (value)
                        {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  content: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("사진 접근 허용을 해주세요!"),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("확인"),
                                          ),
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
                isQuestionClicked = !isQuestionClicked;
                ref
                    .read(isQuestionStateProvider.notifier)
                    .set(isQuestionClicked);
              } else if (widget.icon == Icons.more_horiz) {
                if (widget.commentId != -1) {
                  ref
                      .read(commentStateProvider.notifier)
                      .add(1, widget.commentId);
                } else if (widget.replyId != -1) {
                  ref.read(replyStateProvider.notifier).add(widget.replyId);
                }
                showDialog(
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        actions: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("삭제하기"),
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
                                  child: const Text("수정하기"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }));
              }
            });
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
