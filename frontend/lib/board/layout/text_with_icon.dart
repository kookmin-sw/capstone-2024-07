import 'package:flutter/material.dart';

class TextWithIcon extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  final bool canTap;

  const TextWithIcon({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.text,
    required this.canTap,
  });

  @override
  State<TextWithIcon> createState() => _TextWithIconState();
}

class _TextWithIconState extends State<TextWithIcon>
    with SingleTickerProviderStateMixin {
  // TODO : if user click heart(write comment, favorite), then change icon.
  bool isHeartClicked = false;
  bool isQuestionClicked = false;
  // ignore: prefer_typing_uninitialized_variables
  var textCount;

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    textCount = int.tryParse(widget.text);
    textCount ??= widget.text;
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HeartAnim(
          animationController: animationController,
          isHeartClicked: isHeartClicked,
          widget: widget,
          s: 0.2,
          e: -1.5,
        ),
        HeartAnim(
          animationController: animationController,
          isHeartClicked: isHeartClicked,
          widget: widget,
          s: -0.2,
          e: -1.0,
        ),
        HeartAnim(
          animationController: animationController,
          isHeartClicked: isHeartClicked,
          widget: widget,
          s: 0.3,
          e: -1.2,
        ),
        GestureDetector(
          onTap: () {
            if (widget.canTap) {
              setState(() {
                if (widget.icon == Icons.favorite_outline_rounded) {
                  // TODO: add heartCount to Server
                  if (isHeartClicked) {
                    textCount -= 1;
                    animationController.reverse();
                  } else {
                    textCount += 1;
                    animationController.forward();
                  }
                  isHeartClicked = !isHeartClicked;
                } else if (widget.icon == Icons.chat_outlined) {
                } else if (widget.icon == Icons.star_outline_rounded) {
                } else if (widget.icon == Icons.image_rounded) {
                } else if (widget.icon ==
                    Icons.check_box_outline_blank_rounded) {
                  isQuestionClicked = !isQuestionClicked;
                }
              });
            }
          },
          child: Row(
            children: [
              Icon(
                isHeartClicked
                    ? Icons.favorite
                    : isQuestionClicked
                        ? Icons.check_box_rounded
                        : widget.icon,
                size: widget.iconSize,
                color: isHeartClicked
                    ? Colors.red
                    : isQuestionClicked
                        ? Colors.blue.withOpacity(0.5)
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
    required this.animationController,
    required this.isHeartClicked,
    required this.widget,
    required this.s,
    required this.e,
  });

  final AnimationController animationController;
  final bool isHeartClicked;
  final TextWithIcon widget;
  final double s, e;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 3.0, end: 0.0).animate(CurvedAnimation(
          parent: animationController, curve: Curves.fastLinearToSlowEaseIn)),
      child: SlideTransition(
        position:
            Tween<Offset>(begin: const Offset(0.0, 0.0), end: Offset(s, e))
                .animate(CurvedAnimation(
                    parent: animationController,
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
