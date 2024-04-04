import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImageNotifier extends StateNotifier<List<XFile>> {
  ImageNotifier(this.ref) : super([]);

  final Ref ref;

  Future<void> add(List<XFile> images) async {
    state = images;
  }

  Future<void> clear() async {
    state = List.from(state)..clear();
  }

  Future<void> remove(XFile image) async {
    state = state.where((item) => item != image).toList();
  }
}

final imageStateProvider =
    StateNotifierProvider<ImageNotifier, List<XFile>>((ref) {
  return ImageNotifier(ref);
});
