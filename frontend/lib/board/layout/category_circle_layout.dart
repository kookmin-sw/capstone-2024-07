import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/provider/board_provider.dart';

class CategoryCircle extends ConsumerWidget {
  const CategoryCircle({
    super.key,
    required this.category,
    required this.type,
  });

  final String category;
  final bool type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clickedList = ref.watch(boardStateProvider);
    return GestureDetector(
      onTap: () {
        if (clickedList.contains(category)) {
          ref.read(boardStateProvider.notifier).remove(category);
        } else {
          ref.read(boardStateProvider.notifier).clear();
          ref.read(boardStateProvider.notifier).add(category);
        }
      },
      child: Container(
        // category circle
        decoration: BoxDecoration(
          color: !type
              ? PRIMARY_COLOR.withOpacity(0.1)
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
