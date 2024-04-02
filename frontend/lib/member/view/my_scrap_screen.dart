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
            "스크랩한 글",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
