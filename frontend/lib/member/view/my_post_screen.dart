import 'package:flutter/material.dart';

import '../../common/const/colors.dart';

class MyPostScreen extends StatefulWidget {
  const MyPostScreen({super.key});

  @override
  State<MyPostScreen> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _renderTop(),
          ],
        ),
      ),
    );
  }

  Widget _renderTop(){
    return Container(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
            ),
          ),
          const SizedBox(width: 113.0),
          Text(
            "내가 쓴 글",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
