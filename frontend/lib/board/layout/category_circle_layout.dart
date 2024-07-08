import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/colors.dart';

class CategoryCircle extends ConsumerWidget {
  const CategoryCircle({
    super.key,
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      // category circle
      decoration: BoxDecoration(
        color: PRIMARY10_COLOR,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        child: Text(
          category,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
