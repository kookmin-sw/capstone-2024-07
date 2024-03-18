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
      body: Center(child: Text("내가 댓글단 글")),
    );
  }
}
