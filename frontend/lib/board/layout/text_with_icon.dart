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

class _TextWithIconState extends State<TextWithIcon> {
  // TODO : if user click heart(write comment, favorite), then change icon.
  bool isClicked = false;
  int textCount = 0;

  @override
  void initState() {
    super.initState();
    textCount = int.parse(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.canTap) {
          if (widget.icon == Icons.favorite_outline_rounded) {
            setState(() {
              // TODO: add heartCount to Server
              if (isClicked) {
                textCount -= 1;
              } else {
                textCount += 1;
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
    );
  }
}
