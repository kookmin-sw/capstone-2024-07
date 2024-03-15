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
  bool isClicked = false;
  int textCount = 0;

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    textCount = int.parse(widget.text);
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HeartAnim(
          animationController: animationController,
          isClicked: isClicked,
          widget: widget,
          s: 0.2,
          e: -1.5,
        ),
        HeartAnim(
          animationController: animationController,
          isClicked: isClicked,
          widget: widget,
          s: -0.2,
          e: -1.0,
        ),
        HeartAnim(
          animationController: animationController,
          isClicked: isClicked,
          widget: widget,
          s: 0.3,
          e: -1.2,
        ),
        GestureDetector(
          onTap: () {
            if (widget.canTap) {
              if (widget.icon == Icons.favorite_outline_rounded) {
                setState(() {
                  // TODO: add heartCount to Server
                  if (isClicked) {
                    textCount -= 1;
                    animationController.reverse();
                  } else {
                    textCount += 1;
                    animationController.forward();
                  }
                  isClicked = !isClicked;
                });
              } else if (widget.icon == Icons.chat_outlined) {
              } else if (widget.icon == Icons.star_outline_rounded) {}
            }
          },
          child: Row(
            children: [
              Icon(
                isClicked ? Icons.favorite : widget.icon,
                size: widget.iconSize,
                color: isClicked ? Colors.red : null,
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                textCount != -1 ? "$textCount" : "",
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
    required this.isClicked,
    required this.widget,
    required this.s,
    required this.e,
  });

  final AnimationController animationController;
  final bool isClicked;
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
        child: isClicked
            ? Icon(
                isClicked ? Icons.favorite : widget.icon,
                size: widget.iconSize,
                color: isClicked ? Colors.red : null,
              )
            : null,
      ),
    );
  }
}
