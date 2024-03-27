import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReplyNotifier extends StateNotifier<int> {
  ReplyNotifier(this.ref) : super(-1);

  final Ref ref;

  Future<void> add(int index) async {
    state = index;
  }
}

final replyStateProvider = StateNotifierProvider<ReplyNotifier, int>((ref) {
  return ReplyNotifier(ref);
});
