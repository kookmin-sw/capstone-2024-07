import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/comment_model.dart';

class CommentNotifier extends StateNotifier<List<CommentModel>> {
  CommentNotifier(this.ref) : super([]);

  final Ref ref;

  Future<void> add(CommentModel cocoment) async {
    state = [...state, cocoment];
  }

  Future<void> clear() async {
    state = List.from(state)..clear();
  }
}

final commentStateProvider =
    StateNotifierProvider<CommentNotifier, List<CommentModel>>((ref) {
  return CommentNotifier(ref);
});
