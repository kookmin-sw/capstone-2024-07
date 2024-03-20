import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

//클래스로 상태를 구분할 때는 항상 base class를 만든다.
abstract class CursorPaginationModelBase {}

// 응답이 잘 들어왔을 경우 -> CursorPaginationModel
@JsonSerializable(
  genericArgumentFactories: true, // 제너릭 사용 옵션
)
class CursorPaginationModel<T> extends CursorPaginationModelBase {
  // <T>제너릭 -> CursorPaginationModel을 더 유연하게 사용할 수 있게 해준다.
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPaginationModel({
    required this.meta,
    required this.data,
  });

  CursorPaginationModel<T> copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPaginationModel(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  // T Function(Object? json) fromJsonT -> json을 T타입으로 받을 수 있게 해준다
  // fromJsonT에는 T로 지정해준 타입의 fromJson함수가 들어간다.
  factory CursorPaginationModel.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationModelFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta(
    this.count,
    this.hasMore,
  );

  CursorPaginationMeta copyWith({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMeta(
      count ?? this.count,
      hasMore ?? this.hasMore,
    );
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

// 에러가 났을 경우 -> CursorPaginationModelError
class CursorPaginationModelError extends CursorPaginationModelBase {
  final String message;

  CursorPaginationModelError({
    required this.message,
  });
}

// 로딩중일 경우 -> CursorPaginationModelLoading
class CursorPaginationModelLoading extends CursorPaginationModelBase {}

// 맨 위에서 당겨서 새로고침했을 경우 -> class CursorPaginationModelRefetching
// 이미 데이터가 있는 상태이므로 CursorPaginationModel을 상속한다.
class CursorPaginationModelRefetching<T> extends CursorPaginationModel<T> {
  CursorPaginationModelRefetching({
    required super.meta,
    required super.data,
  });
}

// 맨 아래로 내려서 추가 데이터를 요청하는 경우 -> CursorPaginationFetchingMore
// 이미 데이터가 있는 상태이므로 CursorPaginationModel을 상속한다.
class CursorPaginationModelFetchingMore<T> extends CursorPaginationModel<T> {
  CursorPaginationModelFetchingMore({
    required super.meta,
    required super.data,
  });
}
