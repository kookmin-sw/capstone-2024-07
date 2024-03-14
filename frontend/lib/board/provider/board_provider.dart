import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/msg_board_model.dart';

class BoardNotifier extends StateNotifier<List<MsgBoardModel>> {
  BoardNotifier(this.ref) : super([]);

  final Ref ref;

  Future<void> add(MsgBoardModel board) async {
    state = [...state, board];
  }

  Future<void> clear() async {
    state = List.from(state)..clear();
  }
}

final boardStateProvider =
    StateNotifierProvider<BoardNotifier, List<MsgBoardModel>>((ref) {
  return BoardNotifier(ref);
});
