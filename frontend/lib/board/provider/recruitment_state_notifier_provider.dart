import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/provider/recruitment_add_provider.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';

final recruitmentStateNotifierProvider =
    StateNotifierProvider<RecruitmentStateNotifier, CursorPaginationModelBase>(
  (ref) {
    final repository = ref.watch(recruitmentAddProvider);
    const initialLastPostId = 9223372036854775807;
    const size = 20;

    final notifier = RecruitmentStateNotifier(
        repository: repository, lastId: initialLastPostId, size: size);
    return notifier;
  },
);

class RecruitmentStateNotifier
    extends StateNotifier<CursorPaginationModelBase> {
  bool _mounted = true;
  bool _fetchingData = false;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  final RecruitmentAdd repository;
  int lastId;
  int size;

  RecruitmentStateNotifier({
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

      final resp = await repository.paginate(lastId, size);

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
