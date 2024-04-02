import 'package:flutter/material.dart';

class MyCommentScreen extends StatefulWidget {
  const MyCommentScreen({super.key});

  @override
  State<MyCommentScreen> createState() => _MyCommentScreenState();
}

class _MyCommentScreenState extends State<MyCommentScreen> {
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
            "댓글단 글",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
