import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/cocomment_model.dart';

class CoCommentNotifier extends StateNotifier<List<CoCommentModel>> {
  CoCommentNotifier(this.ref)
      : super([
          CoCommentModel(
            "4",
            "1",
            "1",
            "1",
            "익명4",
            "맞아맞아",
            "2",
          ),
          CoCommentModel(
            "5",
            "1",
            "1",
            "2",
            "익명5",
            "맞아맞아맞아",
            "3",
          ),
        ]);

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
