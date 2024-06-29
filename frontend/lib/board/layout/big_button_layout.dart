import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/provider/board_add_provider.dart';
import 'package:frontend/board/provider/scrap_provider.dart';
import 'package:frontend/common/const/colors.dart';

import 'package:frontend/member/provider/mypage/my_scrap_state_notifier_provider.dart';

class BigButton extends ConsumerStatefulWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  final int postId;
  final bool isClicked;
  final bool isMine;
  final int userId;

  const BigButton({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.text,
    required this.postId,
    required this.isClicked,
    required this.isMine,
    required this.userId,
  });

  @override
  ConsumerState<BigButton> createState() => _BigButtonState();
}

class _BigButtonState extends ConsumerState<BigButton>
    with SingleTickerProviderStateMixin {
  bool isHeart = false;
  bool isHeartClicked = false;
  bool isFavoriteClicked = false;
  bool cantClicked = true;
  // ignore: prefer_typing_uninitialized_variables
  var textCount;

  late AnimationController heartAnimationController;

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
      isHeart = true;
      isHeartClicked = widget.isClicked;
    } else if (widget.icon == Icons.star_outline_rounded) {
      isFavoriteClicked = widget.isClicked;
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
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
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
                }
              }
            } else if (widget.icon == Icons.star_outline_rounded) {
              if (isFavoriteClicked) {
                await ref.read(scrapProvider).delete(widget.postId);
              } else {
                await ref.read(scrapProvider).post(widget.postId);
              }
              ref.read(myScrapStateNotifierProvider.notifier).lastId =
                  9223372036854775807;
              ref
                  .read(myScrapStateNotifierProvider.notifier)
                  .paginate(forceRefetch: true);
              setState(() {
                if (isFavoriteClicked) {
                  textCount -= 1;
                } else {
                  textCount += 1;
                }

                isFavoriteClicked = !isFavoriteClicked;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 0,
                  blurRadius: 1.0,
                  offset: const Offset(0, 1),
                ),
              ],
              color: isHeart ? HEART_BG_COLOR : FAVORITE_BG_COLOR,
            ),
            child: Row(
              children: [
                Icon(
                  isHeartClicked
                      ? Icons.favorite
                      : isFavoriteClicked
                          ? Icons.star
                          : widget.icon,
                  size: widget.iconSize,
                  color: isHeart ? Colors.red : FAVORITE_COLOR,
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  isHeart ? "좋아요 | $textCount" : "스크랩 | $textCount",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          child: HeartAnim(
            heartAnimationController: heartAnimationController,
            isHeartClicked: isHeartClicked,
            widget: widget,
            s: 0.2,
            e: -1.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          child: HeartAnim(
            heartAnimationController: heartAnimationController,
            isHeartClicked: isHeartClicked,
            widget: widget,
            s: -0.2,
            e: -1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          child: HeartAnim(
            heartAnimationController: heartAnimationController,
            isHeartClicked: isHeartClicked,
            widget: widget,
            s: 0.3,
            e: -1.2,
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
                Text(
                  "이미 좋아요를 눌렀습니다.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
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
                    },
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
  final BigButton widget;
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
