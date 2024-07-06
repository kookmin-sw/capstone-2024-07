import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsAnonymousNotifier extends StateNotifier<bool> {
  IsAnonymousNotifier(this.ref) : super(false);

  final Ref ref;

  Future<void> set(bool isClicked) async {
    state = isClicked;
  }
}

final isAnonymousStateProvider =
    StateNotifierProvider<IsAnonymousNotifier, bool>((ref) {
  return IsAnonymousNotifier(ref);
});
