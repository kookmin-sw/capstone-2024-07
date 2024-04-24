import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/colors.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String searchKeyword = '';
  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _renderTextFormField(ref, context),
          ],
        ),
      ),
    );
  }

  Widget _renderTextFormField(WidgetRef ref, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  cursorColor: PRIMARY_COLOR,
                  decoration: InputDecoration(
                    hintText: '검색어를 입력해주세요.',
                    hintStyle: TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 30.0,
                      ),
                      color: PRIMARY_COLOR,
                      onPressed: () {
                        setState(() {
                          isSearched = true;
                        });
                        //검색 실행
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(
                          color: PRIMARY_COLOR,
                          width: 1.5), // Set your color for the border here
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(
                          color: PRIMARY_COLOR,
                          width: 2.5), // Set your color for the border here
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      searchKeyword = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 60,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('취소'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
