import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/provider/search_state_notifier_provider.dart';
import 'package:frontend/board/provider/searck_keyword_provider.dart';

import '../../common/const/colors.dart';
import '../../common/model/cursor_pagination_model.dart';
import '../component/board_card.dart';
import '../model/msg_board_response_model.dart';
import '../provider/board_detail_state_notifier_provider.dart';
import 'msg_board_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final ScrollController controller = ScrollController();
  String searchKeyword = '';
  bool isSearched = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(scrollListener);
    controller.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (controller.offset > controller.position.maxScrollExtent - 150) {
      ref.read(searchStateNotifierProvider.notifier).paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _renderTextFormField(ref, context),
            if (!isSearched)
              const Expanded(
                child: Center(
                  child: Text(
                    '궁금한 내용을 검색해보세요!',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: BODY_TEXT_COLOR,
                    ),
                  ),
                ),
              ),
            if (isSearched)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: _renderSearchedList(),
                ),
              ),
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
                    hintStyle: const TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 30.0,
                      ),
                      color: PRIMARY_COLOR,
                      onPressed: () => search(ref),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(
                          color: PRIMARY_COLOR,
                          width: 1.5), // Set your color for the border here
                    ),
                    focusedBorder: const OutlineInputBorder(
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
                    ref.read(searchKeywordProvider.notifier).state = value;
                  },
                  onFieldSubmitted: (String value) => search(ref),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 60,
                  child: TextButton(
                    onPressed: () {
                      ref.read(searchKeywordProvider.notifier).state = '';
                      ref.read(searchStateNotifierProvider.notifier).resetSearchResults();
                      setState(() {
                        searchKeyword = '';
                        isSearched = false;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('취소'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void search(WidgetRef ref) {
    if (searchKeyword.isNotEmpty) {
      setState(() {
        isSearched = true;
      });
      ref.read(searchStateNotifierProvider.notifier).updateAndFetch(searchKeyword);
    }
  }

  Widget _renderSearchedList() {
    final data = ref.watch(searchStateNotifierProvider);

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

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(searchStateNotifierProvider.notifier).lastId =
            9223372036854775807;
        await ref
            .read(searchStateNotifierProvider.notifier)
            .paginate(forceRefetch: true);
      },
      child: ListView.separated(
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
      ),
    );
  }
}
