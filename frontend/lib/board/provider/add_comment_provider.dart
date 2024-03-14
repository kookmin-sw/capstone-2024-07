import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCommentNotifier extends StateNotifier<String> {
  AddCommentNotifier(this.ref) : super("0");

  final Ref ref;

  Future<void> add(String commentId) async {
    state = commentId;
  }
}

final addCommentStateProvider =
    StateNotifierProvider<AddCommentNotifier, String>((ref) {
  return AddCommentNotifier(ref);
});
