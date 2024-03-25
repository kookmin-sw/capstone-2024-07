import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsQuestionNotifier extends StateNotifier<bool> {
  IsQuestionNotifier(this.ref) : super(false);

  final Ref ref;

  Future<void> set(bool isClicked) async {
    state = isClicked;
  }
}

final isQuestionStateProvider =
    StateNotifierProvider<IsQuestionNotifier, bool>((ref) {
  return IsQuestionNotifier(ref);
});
