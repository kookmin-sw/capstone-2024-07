import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentNotifier extends StateNotifier<List<int>> {
  CommentNotifier(this.ref) : super([-1, -1]);

  final Ref ref;

  Future<void> add(int type, int index) async {
    if (type == 0) {
      // add comment
      state = [index, -1];
    } else {
      // modify comment
      state = [-1, index];
    }
  }
}

final commentStateProvider =
    StateNotifierProvider<CommentNotifier, List<int>>((ref) {
  return CommentNotifier(ref);
});
