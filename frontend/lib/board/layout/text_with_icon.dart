import 'package:flutter/material.dart';

class TextWithIcon extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  const TextWithIcon({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.text,
  });

  @override
  State<TextWithIcon> createState() => _TextWithIconState();
}

class _TextWithIconState extends State<TextWithIcon> {
  // TODO : if user click heart(write comment, favorite), then change icon.
  bool heartClicked = false;
  int heartCount = 0;

  @override
  void initState() {
    super.initState();
    heartCount = int.parse(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.icon == Icons.favorite_outline_rounded) {
          setState(() {
            // TODO: add heartCount to Server
            if (heartClicked) {
              heartCount -= 1;
            } else {
              heartCount += 1;
            }
            heartClicked = !heartClicked;
          });
        } else if (widget.icon == Icons.chat_outlined) {
        } else if (widget.icon == Icons.star_outline_rounded) {}
      },
      child: Row(
        children: [
          Icon(
            heartClicked ? Icons.favorite : widget.icon,
            size: widget.iconSize,
            color: heartClicked ? Colors.red : null,
          ),
          const SizedBox(
            width: 2,
          ),
          Text(
            "$heartCount",
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
