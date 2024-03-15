import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/comment_model.dart';

class CommentNotifier extends StateNotifier<List<CommentModel>> {
  CommentNotifier(this.ref)
      : super(
          [
            CommentModel(
              "1",
              "1",
              "1",
              "익명1",
              "ㅇㅈ",
              "0",
            ),
            CommentModel(
              "2",
              "1",
              "2",
              "익명2",
              "ㅇㅈㅇㅈ",
              "0",
            ),
            CommentModel(
              "3",
              "1",
              "3",
              "익명3",
              "ㅆㅇㅈ",
              "0",
            ),
            CommentModel(
              "4",
              "1",
              "4",
              "익명4",
              "ㅆㅆㅇㅈ",
              "0",
            ),
            CommentModel(
              "5",
              "1",
              "5",
              "익명5",
              "ㅆㅆㅆㅇㅈ",
              "0",
            ),
            CommentModel(
              "1",
              "2",
              "1",
              "익명1",
              "종강",
              "0",
            ),
            CommentModel(
              "5",
              "1",
              "6",
              "익명5",
              "종종강",
              "0",
            ),
          ],
        );

  final Ref ref;

  Future<void> add(CommentModel cocoment) async {
    state = [...state, cocoment];
  }

  Future<void> clear() async {
    state = List.from(state)..clear();
  }
}

final commentStateProvider =
    StateNotifierProvider<CommentNotifier, List<CommentModel>>((ref) {
  return CommentNotifier(ref);
});
