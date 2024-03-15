import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/member_state_notifier_provider.dart';

class MypageScreen extends ConsumerStatefulWidget {
  const MypageScreen({super.key});

  @override
  ConsumerState<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends ConsumerState<MypageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("마이페이지"),
          Center(
            child: ElevatedButton(
              onPressed: () {
                ref.read(memberStateNotifierProvider.notifier).logout();
              },
              child: const Text('로그아웃'),
            ),
          ),
        ],
      ),
    );
  }
}
