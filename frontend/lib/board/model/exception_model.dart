import 'package:json_annotation/json_annotation.dart';

part 'exception_model.g.dart';

@JsonSerializable()
class ExceptionModel {
  final String code;
  final String message;

  factory ExceptionModel.fromJson(Map<String, dynamic> json) =>
      _$ExceptionModelFromJson(json);

  ExceptionModel(this.code, this.message);
}
