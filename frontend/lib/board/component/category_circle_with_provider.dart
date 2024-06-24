import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/fonts.dart';

import '../../common/const/colors.dart';
import '../provider/api_category_provider.dart';
import '../provider/category_provider.dart';

class CategoryCircleWithProvider extends ConsumerWidget {
  const CategoryCircleWithProvider({
    super.key,
    required this.category,
    required this.categoryCode,
  });

  final String category;
  final String? categoryCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clickedList = ref.watch(categoryStateProvider);
    final isClicked = clickedList.contains(category);

    return GestureDetector(
      onTap: () {
        if (categoryCode == "HOT") {
          ref.read(categoryTitleProvider.notifier).state = null;
          ref.read(isHotProvider.notifier).state = true;
        } else if (categoryCode == "ALL") {
          ref.read(categoryTitleProvider.notifier).state = null;
          ref.read(isHotProvider.notifier).state = false;
        } else {
          ref.read(categoryTitleProvider.notifier).state = categoryCode;
          ref.read(isHotProvider.notifier).state = false;
        }

        ref.read(categoryStateProvider.notifier).clear();
        ref.read(categoryStateProvider.notifier).add(category);
      },
      child: Container(
        // category circle
        decoration: BoxDecoration(
          color: isClicked ? CATEGORY_COLOR : BODY_TEXT_COLOR,
          borderRadius: BorderRadius.circular(50),
        ),
        child: SizedBox(
          height: 40.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
            child: Center(
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: isClicked
                      ? MyFontFamily.GmarketSansBold
                      : MyFontFamily.GmarketSansMedium,
                  color: isClicked ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
