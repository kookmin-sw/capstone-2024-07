import 'package:flutter/material.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/common/view/msg_board_list_screen.dart';

class RootTab extends StatefulWidget {
  final int initialIndex;

  const RootTab({
    required this.initialIndex,
    super.key,
  });

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
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
        children: const [
          Center(child: Text('홈')),
          MsgBoardListScreen(category: "인기글"),
          Center(child: Text('마이페이지')),
          Center(child: Text('더보기')),
        ],
      ),
    );
  }
}
