import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/component/study_board_card.dart';
import 'package:frontend/board/provider/search_state_notifier_provider.dart';
import 'package:frontend/board/view/study_board_screen.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';
import 'package:frontend/board/model/recruitment_response_model.dart';
import 'package:frontend/board/component/board_card.dart';
import 'package:frontend/board/view/msg_board_screen.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final ScrollController controller = ScrollController();
  String searchKeyword = '';
  bool isSearched = false;
  String searchType = '일반';

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
      backgroundColor: Colors.white,
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
              DropdownButton<String>(
                value: searchType,
                items: <String>['일반', '스터디'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    searchType = newValue!;
                  });
                },
              ),
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
                      borderSide: BorderSide(color: PRIMARY_COLOR, width: 1.5),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: PRIMARY_COLOR, width: 2.5),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      searchKeyword = value;
                    });
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
                      setState(() {
                        searchKeyword = '';
                        isSearched = false;
                      });
                      ref.read(searchStateNotifierProvider.notifier).resetSearchResults();
                      context.pop();
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
      ref.read(searchStateNotifierProvider.notifier).updateAndFetch(searchKeyword, searchType);
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

    if (cp.data.isEmpty) {
      return const Center(
        child: Text(
          "검색된 내용이 없습니다.",
          style: TextStyle(color: Colors.grey, fontSize: 16.0),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(searchStateNotifierProvider.notifier).lastId =
        9223372036854775807;
        await ref.read(searchStateNotifierProvider.notifier).paginate(forceRefetch: true);
      },
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length,
        itemBuilder: (_, index) {
          final item = cp.data[index];
          if (item is MsgBoardResponseModel) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MsgBoardScreen(board: item),
                  ),
                );
              },
              child: BoardCard.fromModel(msgBoardResponseModel: item),
            );
          } else if (item is RecruitmentResponseModel) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudyBoardScreen(board: item),
                  ),
                );
              },
              child: StudyBoardCard(recruitmentResponseModel: item),
            );
          } else {
            return const SizedBox.shrink(); // 알 수 없는 타입의 경우 빈 위젯 반환
          }
        },
        separatorBuilder: (_, index) {
          return const SizedBox(height: 1.0);
        },
      ),
    );
  }
}
