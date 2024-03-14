import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/cocomment_model.dart';

class CoCommentNotifier extends StateNotifier<List<CoCommentModel>> {
  CoCommentNotifier(this.ref) : super([]);

  final Ref ref;

  Future<void> add(CoCommentModel cocoment) async {
    state = [...state, cocoment];
  }

  Future<void> clear() async {
    state = List.from(state)..clear();
  }
}

final cocommentStateProvider =
    StateNotifierProvider<CoCommentNotifier, List<CoCommentModel>>((ref) {
  return CoCommentNotifier(ref);
});
