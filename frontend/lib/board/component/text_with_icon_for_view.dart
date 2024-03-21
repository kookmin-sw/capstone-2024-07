import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextWithIconForView extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  const TextWithIconForView({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.text,
  });

  @override
  State<TextWithIconForView> createState() => _TextWithIconForViewState();
}

class _TextWithIconForViewState extends State<TextWithIconForView> {
  // TODO : if user click heart(write comment, favorite), then change icon.
  bool heartClicked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.icon == Icons.favorite_outline_rounded) {
          setState(() {
            heartClicked = !heartClicked;
          });
        }
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
            widget.text,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}