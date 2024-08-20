import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/provider/board_detail_state_notifier_provider.dart';
import 'package:frontend/board/provider/recruitment_comment_provider.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';

final recruitmentCommentPaginationProvider = StateNotifierProvider<
    RecruitmentCommentPaginationNotifier, CursorPaginationModelBase>(
  (ref) {
    final recruitmentCommentNotifier = ref.watch(recruitmentCommentProvider);
    final recruitmentId = ref.watch(boardDetailNotifier);
    const lastCommentId = 0;
    const size = 15;

    final notifier = RecruitmentCommentPaginationNotifier(
      recruitmentCommentNotifier: recruitmentCommentNotifier,
      recruitmentId: recruitmentId,
      lastCommentId: lastCommentId,
      size: size,
    );
    return notifier;
  },
);

class RecruitmentCommentPaginationNotifier
    extends StateNotifier<CursorPaginationModelBase> {
  bool _mounted = true;
  bool _fetchingData = false;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  final RecruitmentCommentNotifier recruitmentCommentNotifier;
  int recruitmentId;
  int lastCommentId;
  int size;

  RecruitmentCommentPaginationNotifier({
    required this.recruitmentCommentNotifier,
    required this.recruitmentId,
    required this.lastCommentId,
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
        lastCommentId = pState.data.last.id;
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
        lastCommentId = 0;
      }
      final resp = await recruitmentCommentNotifier.paginate(
          recruitmentId, lastCommentId, size);

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

      debugPrint(
          "RecruitmentCommentPaginationError : ${e.runtimeType.toString()}");

      state = CursorPaginationModelError(message: '데이터를 가져오지 못했습니다');
    } finally {
      _fetchingData = false;
    }
  }
}
