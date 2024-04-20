import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/member/provider/mypage/my_comment_state_notifier_provider.dart';

import '../../board/component/board_card.dart';
import '../../board/model/msg_board_response_model.dart';
import '../../board/provider/board_detail_state_notifier_provider.dart';
import '../../board/view/msg_board_screen.dart';
import '../../common/const/colors.dart';
import '../../common/model/cursor_pagination_model.dart';

class MyCommentScreen extends ConsumerStatefulWidget {
  const MyCommentScreen({super.key});

  @override
  ConsumerState<MyCommentScreen> createState() => _MyCommentScreenState();
}

class _MyCommentScreenState extends ConsumerState<MyCommentScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    if (controller.offset > controller.position.maxScrollExtent - 150) {
      ref.read(myCommentStateNotifierProvider.notifier).paginate(
            fetchMore: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _renderTop(),
            Expanded(
              child: _renderMyCommentedPostList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderTop() {
    return Container(
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.chevron_left,
                ),
              ),
            ],
          ),
          const Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "댓글단 글",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderMyCommentedPostList() {
    final data = ref.watch(myCommentStateNotifierProvider);

    if (data is CursorPaginationModelLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: PRIMARY_COLOR,
        ),
      );
    }

    if (data is CursorPaginationModelError) {
      return const Center(
        child: Text("데이터를 불러올 수 없습니다."),
      );
    }

    final cp = data as CursorPaginationModel;

    return ListView.separated(
      controller: controller,
      itemCount: cp.data.length + 1,
      itemBuilder: (_, index) {
        if (index == cp.data.length) {
          return Center(
            child: cp is CursorPaginationModelFetchingMore
                ? const CircularProgressIndicator(
                    color: PRIMARY_COLOR,
                  )
                : const Text(
                    'Copyright 2024. Decl Team all rights reserved.\n',
                    style: TextStyle(
                      color: BODY_TEXT_COLOR,
                      fontSize: 12.0,
                    ),
                  ),
          );
        }

        final MsgBoardResponseModel pItem = cp.data[index];

        return GestureDetector(
          child: BoardCard.fromModel(msgBoardResponseModel: pItem),
          onTap: () async {
            // 상세페이지
            ref.read(boardDetailNotifier.notifier).add(pItem.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MsgBoardScreen(
                        board: pItem,
                      ),
                  fullscreenDialog: true),
            );
          },
        );
      },
      separatorBuilder: (_, index) {
        return const SizedBox(height: 1.0);
      },
    );
  }
}
