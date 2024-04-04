import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkImageNotifier extends StateNotifier<List<String>> {
  NetworkImageNotifier(this.ref) : super([]);

  final Ref ref;

  Future<void> add(String image) async {
    state = List.from(state)..add(image);
  }

  Future<void> clear() async {
    state = List.from(state)..clear();
  }

  Future<void> remove(String image) async {
    state = state.where((item) => item != image).toList();
  }
}

final networkImageStateProvider =
    StateNotifierProvider<NetworkImageNotifier, List<String>>((ref) {
  return NetworkImageNotifier(ref);
});
