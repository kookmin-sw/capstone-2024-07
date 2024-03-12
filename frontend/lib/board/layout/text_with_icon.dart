import 'package:flutter/material.dart';

class TextWithIcon extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  const TextWithIcon({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.text,
  });

  // TODO : if user click heart(write comment, favorite), then change icon.
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
