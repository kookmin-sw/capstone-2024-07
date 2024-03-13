import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/view/msg_board_list_screen.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/common/layout/default_layout.dart';

import '../../member/provider/member_state_notifier_provider.dart';

class RootTab extends ConsumerStatefulWidget {
  static String get routeName => 'home';
  final int initialIndex;

  const RootTab({
    required this.initialIndex,
    super.key,
  });

  @override
  ConsumerState<RootTab> createState() => _RootTabState();
}

class _RootTabState extends ConsumerState<RootTab>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(
        length: 4, vsync: this, initialIndex: widget.initialIndex);
    controller.addListener(tabListener);
    index = widget.initialIndex;
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 8.0,
        unselectedFontSize: 10.0,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 24.0,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt,
              size: 24.0,
            ),
            label: '게시판',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outlined,
              size: 24.0,
            ),
            label: '마이페이지',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.more_horiz,
              size: 24.0,
            ),
            label: '더보기',
          ),
        ],
        selectedLabelStyle: const TextStyle(
          fontSize: 12.0,
        ),
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          const Center(child: Text('홈')),
          const MsgBoardListScreen(),
          const Center(child: Text('마이페이지')),
          Center(
              child: ElevatedButton(
            onPressed: () {
              ref.read(memberStateNotifierProvider.notifier).logout();
            },
            child: const Text('로그아웃'),
          )),
        ],
      ),
    );
  }
}
