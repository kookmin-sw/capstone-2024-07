import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/board/provider/board_repository_provider.dart';
import 'package:frontend/common/model/cursor_pagination_model.dart';

import 'api_category_provider.dart';

final boardStateNotifierProvider = StateNotifierProvider<BoardStateNotifier, CursorPaginationModelBase>((ref){
  final repository = ref.watch(boardRepositoryProvider);
  const initialLastPostId = 9223372036854775807; //maxValue를 담아 넘겨야 하나...?
  final communityTitle = ref.watch(categoryTitleProvider);
  final isHot = ref.watch(isHotProvider);
  const size = 10;

  final notifier = BoardStateNotifier(repository: repository, lastId: initialLastPostId, communityTitle: communityTitle, size: size, isHot: isHot);
  return notifier;
},);

class BoardStateNotifier extends StateNotifier<CursorPaginationModelBase>{
  bool _mounted = true;
  bool _fetchingData = false;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  final BoardRepository repository;
  int lastId;
  String communityTitle;
  int size;
  bool isHot;

  BoardStateNotifier({
    required this.repository,
    required this.lastId,
    required this.communityTitle,
    required this.size,
    required this.isHot,
  }) : super(CursorPaginationModelLoading()){
    paginate();
  }

  bool get isMounted => _mounted;

  Future<void> paginate({
    // fetchMore : 추가로 데이터를 더 가져와야하는지 여부
    // true - 추가로 데이터 더 가져옴
    // false - 새로고침 (현재 페이지 범위에서 새로고침)
    bool fetchMore = false,
    // forceRefetching : 강제로 다시 로딩하기 위한 요청인지 여부
    // true - CursorPaginationModelLoading
    bool forceRefetch = false,
  }) async {

    // Notifier가 dispose된 상태라면 작업을 수행하지 않는다.
    // 첫번째 확인 -> 메서드 시작시
    if (!isMounted) return;

    // 이미 paginate() 작업이 진행 중인지 확인
    if (_fetchingData) return;
    _fetchingData = true;

    try{
      // 5가지 가능성 (state의 상태) -> CursorPaginationModelBase를 상속하는 클래스가 5개이기 때문이다.
      // 1) CursorPaginationModel - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationModelLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
      // 3) CursorPaginationModelError - 에러가 있는 상태
      // 4) CursorPaginationModelRefetching - 첫번째 페이지부터 다시 데이터를 가져올 때
      // 5) CursorPaginationModelFetchingMore - 추가 데이터를 paginate 해오라는 요청을 받았을 때

      // 바로 반환하는 상황 1: hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고 있음)
      if (state is CursorPaginationModel && !forceRefetch) {
        // forceRefetch가 true이면 paginate() 로직을 실행해줘야 하므로 바로 반환하면 안되고, false인 경우만 다룬다.
        final pState = state as CursorPaginationModel;

        if (!pState.meta.hasMore) {
          // forceRefetch도 false고 hasMore가 false이면 바로 리턴.
          return;
        }
      }

      // 바로 반환하는 상황 2: 로딩중인데 fetchMore가 true일때 -> 추가 데이터를 가져와야 하는 상황이므로 paginate를 실행하지 않는다. (중복 요청을 막기 위해)
      // but!! 로딩중인데 fetchMore가 false일떼 -> 원래대로 paginate 로직을 실행한다.
      // 아래는 로딩 상태 3가지
      final isLoading = state is CursorPaginationModelLoading;
      final isRefetching = state is CursorPaginationModelRefetching;
      final isFetchingMore = state is CursorPaginationModelFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // fetchingMore -> 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = (state as CursorPaginationModel); // 무조건 데이터를 들고있는 상황

        state = CursorPaginationModelFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        // paginate 파라미터 변경
        lastId = pState.data.last.id;

      } else {
        // fetchMore가 false -> 데이터를 처음부터 가져오는 상황
        // 만약 데이터가 있는 상황이라면 기존 데이터를 보존한 채로 api 요청을 진행
        if (state is CursorPaginationModel && !forceRefetch) {
          final pState = state as CursorPaginationModel;

          state = CursorPaginationModelRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          //나머지 상황 -> 데이터를 유지할 필요가 없는 상황
          state = CursorPaginationModelLoading();
        }
      }

      // resp: 새로 받아온 데이터
      final resp = await repository.paginate(lastId, communityTitle, size, isHot);

      // Notifier가 dispose된 상태라면 작업을 수행하지 않는다.
      // 두번째 확인 -> 비동기 작업 후
      if (!isMounted) return;

      // 결과를 잘 가져왔으면 여기로 들어온다.
      if (state is CursorPaginationModelFetchingMore) {
        // pState: 기존에 있던 데이터
        final pState = state as CursorPaginationModelFetchingMore;

        // 기존 데이터에 새로운 데이터 추가.
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else{
        // state가 CursorPaginationModelFetchingMore이 아니면
        // 즉, CursorPaginationModelRefetching이거나 CursorPaginationModelLoading이면
        //fetchMore이 아닐 경우에는 pagination 파라미터가 변경되지 않으므로, resp가 맨처음 그대로다!
        state = resp;
      }
    } catch(e){
      // Notifier가 dispose된 상태라면 작업을 수행하지 않는다.
      // 세번째 확인 -> 에러 발생 후
      if (!isMounted) return;

      print(e.runtimeType);

      state = CursorPaginationModelError(message: '데이터를 가져오지 못했습니다');
    } finally {
      _fetchingData = false;
    }
  }
}