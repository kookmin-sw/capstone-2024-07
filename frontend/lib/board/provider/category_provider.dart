import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryNotifier extends StateNotifier<List<String>> {
  CategoryNotifier(this.ref) : super(["전체"]);

  final Ref ref;

  Future<void> add(String category) async {
    state = [...state, category];
  }

  Future<void> remove(String category) async {
    state = List.from(state)..remove(category);
  }

  Future<void> clear() async {
    state = List.from(state)..clear();
  }
}

final categoryStateProvider =
    StateNotifierProvider<CategoryNotifier, List<String>>((ref) {
  return CategoryNotifier(ref);
});
