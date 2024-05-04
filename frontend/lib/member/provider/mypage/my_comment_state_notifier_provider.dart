import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/model/cursor_pagination_model.dart';
import '../my_page_repository_provider.dart';

final myCommentStateNotifierProvider =
StateNotifierProvider<MyCommentStateNotifier, CursorPaginationModelBase>(
        (ref) {
      final repository = ref.watch(myPageRepositoryProvider);
      const initialLastPostId = 9223372036854775807;
      const size = 20;

      final notifier = MyCommentStateNotifier(
        repository: repository,
        lastId: initialLastPostId,
        size: size,
      );

      return notifier;
    });

class MyCommentStateNotifier extends StateNotifier<CursorPaginationModelBase> {
  bool _mounted = true;
  bool _fetchingData = false;

  void clearData() {
    state = CursorPaginationModelLoading();
  }

  void fetchData() {
    paginate(forceRefetch: true);
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  final MyPageRepository repository;
  int lastId;
  int size;

  MyCommentStateNotifier({
    required this.repository,
    required this.lastId,
    required this.size,
  }) : super(CursorPaginationModelLoading()) {
    paginate();
  }

  bool get isMounted => _mounted;

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
        final pState = (state as CursorPaginationModel); // 무조건 데이터를 들고있는 상황

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
      final resp = await repository.getCommentedPosts(lastId, size);

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
