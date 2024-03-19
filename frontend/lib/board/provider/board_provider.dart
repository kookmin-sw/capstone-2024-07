import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/model/msg_board_model.dart';

class BoardNotifier extends StateNotifier<List<MsgBoardModel>> {
  BoardNotifier(this.ref)
      : super(
          [
            MsgBoardModel(
              "1",
              "1",
              "인기게시판",
              "종강마렵다",
              "ㅈㄱㄴssssssssssssssssssssssssssssssssssssssssssssssssssddddddddddddpppppabcdefg",
              "20",
              "3",
              "0",
              "24/03/04 13:45",
              "익명",
            ),
            MsgBoardModel(
              "2",
              "2",
              "인기게시판",
              "종강종강",
              "종강종강종강종강",
              "15",
              "2",
              "0",
              "24/03/04 14:45",
              "익명",
            ),
            MsgBoardModel(
              "3",
              "3",
              "인기게시판",
              "토끼는 깡종강종강",
              "거북이도 종강종강",
              "10",
              "4",
              "0",
              "24/03/04 15:45",
              "익명",
            ),
            MsgBoardModel(
              "4",
              "4",
              "인기게시판",
              "교수님 정강이 때릴 사람 구합니다.",
              "아이고 종강이야",
              "5",
              "3",
              "0",
              "24/03/04 16:45",
              "익명",
            ),
            MsgBoardModel(
              "5",
              "5",
              "인기게시판",
              "슬슬 종강할 때 되지 않았나",
              "눈치껏 종강하자",
              "6",
              "2",
              "0",
              "24/03/04 17:45",
              "익명",
            ),
            MsgBoardModel(
              "6",
              "6",
              "인기게시판",
              "그냥 종강좀 해라",
              "이만큼 했음 됬지 않늬",
              "3",
              "1",
              "0",
              "24/03/04 18:45",
              "익명",
            ),
          ],
        );

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
