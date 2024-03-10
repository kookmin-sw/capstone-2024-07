import 'package:flutter/material.dart';
import 'package:frontend/common/const/colors.dart';

class CategoryCircle extends StatefulWidget {
  const CategoryCircle({
    super.key,
    required this.category,
    required this.type,
  });

  final String category;
  final bool type;

  @override
  State<CategoryCircle> createState() => _CategoryCircleState();
}

class _CategoryCircleState extends State<CategoryCircle> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.type) {
          setState(() {
            clicked = !clicked;
          });
        }
      },
      child: Container(
        // category circle
        decoration: BoxDecoration(
          color: !widget.type
              ? PRIMARY_COLOR.withOpacity(0.1)
              : !clicked
                  ? BODY_TEXT_COLOR.withOpacity(0.1)
                  : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: clicked
              ? Border.all(
                  color: PRIMARY_COLOR,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: Text(
            widget.category,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
