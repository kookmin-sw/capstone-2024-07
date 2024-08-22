import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/provider/search_repository_provider.dart';
import 'package:frontend/board/provider/searck_keyword_provider.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';

final searchStateNotifierProvider =
    StateNotifierProvider<SearchStateNotifier, CursorPaginationModelBase>(
  (ref) {
    final repository = ref.watch(searchRepositoryProvider);
    const initialLastPostId = 9223372036854775807;
    const size = 10;
    final keyword = ref.watch(searchKeywordProvider.notifier).state;

    final notifier = SearchStateNotifier(
      repository: repository,
      lastId: initialLastPostId,
      size: size,
      keyword: keyword,
    );
    return notifier;
  },
);

class SearchStateNotifier extends StateNotifier<CursorPaginationModelBase> {
  bool _mounted = true;
  bool _fetchingData = false;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  final SearchRepository repository;
  int lastId;
  int size;
  String keyword;
  String searchType = '일반'; // 검색 유형을 저장하는 변수

  SearchStateNotifier({
    required this.repository,
    required this.lastId,
    required this.size,
    required this.keyword,
  }) : super(CursorPaginationModelLoading()) {
    paginate();
  }

  bool get isMounted => _mounted;

  void updateAndFetch(String newKeyword, String newSearchType) {
    keyword = newKeyword;
    searchType = newSearchType; // 검색 유형 업데이트
    lastId = 9223372036854775807;
    paginate(forceRefetch: true);
  }

  void resetSearchResults() {
    state = CursorPaginationModelLoading();
  }

  Future<void> paginate({
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    if (!isMounted) return;

    if (_fetchingData) return;
    _fetchingData = true;

    try {
      if (state is CursorPaginationModel && !forceRefetch) {
        final pState = state as CursorPaginationModel;

        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationModelLoading;
      final isRefetching = state is CursorPaginationModelRefetching;
      final isFetchingMore = state is CursorPaginationModelFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      if (fetchMore) {
        final pState = (state as CursorPaginationModel);

        state = CursorPaginationModelFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );
        lastId = pState.data.last.id;
      } else {
        if (state is CursorPaginationModel && !forceRefetch) {
          final pState = state as CursorPaginationModel;

          state = CursorPaginationModelRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          state = CursorPaginationModelLoading();
        }
      }

      // 검색 유형에 따라 다른 API 호출
      final resp = searchType == '일반'
          ? await repository.paginate(lastId, size, keyword)
          : await repository.searchRecruitment(lastId, size, keyword);

      if (!isMounted) return;

      if (state is CursorPaginationModelFetchingMore) {
        final pState = state as CursorPaginationModelFetchingMore;
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e) {
      if (!isMounted) return;

      print(e.runtimeType);

      state = CursorPaginationModelError(message: '데이터를 가져오지 못했습니다');
    } finally {
      _fetchingData = false;
    }
  }
}
