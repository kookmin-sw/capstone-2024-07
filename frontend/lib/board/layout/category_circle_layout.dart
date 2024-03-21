import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/provider/api_category_provider.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/provider/category_provider.dart';

class CategoryCircle extends ConsumerWidget {
  const CategoryCircle({
    super.key,
    required this.category,
    required this.categoryCode,
    required this.type,
  });

  final String category;
  final String categoryCode;
  final bool type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if(categoryCode=="HOT"){
          ref.read(categoryTitleProvider.notifier).state = null;
          ref.read(isHotProvider.notifier).state = true;
        } else {
          ref.read(categoryTitleProvider.notifier).state = categoryCode;
          ref.read(isHotProvider.notifier).state = false;
        }

      },
      child: Container(
        // category circle
        decoration: BoxDecoration(
          color: !type
              ? PRIMARY_COLOR.withOpacity(0.1)
              : BODY_TEXT_COLOR.withOpacity(0.1),
          borderRadius: BorderRadius.circular(50),
          border: type
              ? Border.all(
                  color: PRIMARY_COLOR,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: Center(
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
