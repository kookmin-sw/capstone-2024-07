import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoardDetailNotifier extends StateNotifier<int> {
  BoardDetailNotifier(this.ref) : super(-1);

  final Ref ref;

  Future<void> add(int postId) async {
    state = postId;
  }
}

final boardDetailNotifier =
    StateNotifierProvider<BoardDetailNotifier, int>((ref) {
  return BoardDetailNotifier(ref);
});
