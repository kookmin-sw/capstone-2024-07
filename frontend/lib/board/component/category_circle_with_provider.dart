import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/colors.dart';
import '../provider/api_category_provider.dart';
import '../provider/category_provider.dart';

class CategoryCircleWithProvider extends ConsumerWidget {
  const CategoryCircleWithProvider({
    super.key,
    required this.category,
    required this.categoryCode,
    required this.type,
  });

  final String category;
  final String? categoryCode;
  final bool type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clickedList = ref.watch(categoryStateProvider);

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

          if (clickedList.contains(category)) {
            ref.read(categoryStateProvider.notifier).remove(category);
          } else {
            ref.read(categoryStateProvider.notifier).clear();
            ref.read(categoryStateProvider.notifier).add(category);
          }
        }
      },
      child: Container(
        // category circle
        decoration: BoxDecoration(
          color: !type
              ? PRIMARY10_COLOR
              : !clickedList.contains(category)
                  ? BODY_TEXT_COLOR.withOpacity(0.1)
                  : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: type && clickedList.contains(category)
              ? Border.all(
                  color: PRIMARY_COLOR,
                )
              : null,
        ),
        child: SizedBox(
          height: 40.0,
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
      ),
    );
  }
}
