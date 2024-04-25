import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextWithIconForView extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  final Color? color;

  const TextWithIconForView({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.text,
    this.color,
  });

  @override
  State<TextWithIconForView> createState() => _TextWithIconForViewState();
}

class _TextWithIconForViewState extends State<TextWithIconForView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          widget.icon,
          color: widget.color,
          size: widget.iconSize,
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
    );
  }
}
