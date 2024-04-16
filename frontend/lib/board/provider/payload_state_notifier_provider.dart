import 'package:flutter_riverpod/flutter_riverpod.dart';

class PayloadNotifier extends StateNotifier<String> {
  PayloadNotifier(this.ref) : super("");

  final Ref ref;

  Future<void> add(String postId) async {
    state = postId;
  }
}

final payloadNotifier = StateNotifierProvider<PayloadNotifier, String>((ref) {
  return PayloadNotifier(ref);
});
