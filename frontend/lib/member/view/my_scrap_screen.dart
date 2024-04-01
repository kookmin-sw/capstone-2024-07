import 'package:flutter/material.dart';

class MyScrapScreen extends StatefulWidget {
  const MyScrapScreen({super.key});

  @override
  State<MyScrapScreen> createState() => _MyScrapScreenState();
}

class _MyScrapScreenState extends State<MyScrapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("스크랩 한 글")),
    );
  }
}
