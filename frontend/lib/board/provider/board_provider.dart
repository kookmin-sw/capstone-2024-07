import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoardNotifier extends StateNotifier<List<String>> {
  BoardNotifier(this.ref) : super([]);

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

final boardStateProvider =
    StateNotifierProvider<BoardNotifier, List<String>>((ref) {
  return BoardNotifier(ref);
});
