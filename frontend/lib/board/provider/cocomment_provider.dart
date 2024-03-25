import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/comment_model.dart';

class ReplyNotifier extends StateNotifier<List<ReplyModel>> {
  ReplyNotifier(this.ref) : super([]);

  final Ref ref;

  Future<void> add(ReplyModel cocoment) async {
    state = [...state, cocoment];
  }

  Future<void> clear() async {
    state = List.from(state)..clear();
  }
}

final replyStateProvider =
    StateNotifierProvider<ReplyNotifier, List<ReplyModel>>((ref) {
  return ReplyNotifier(ref);
});
