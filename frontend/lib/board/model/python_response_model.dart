import 'package:json_annotation/json_annotation.dart';

part 'python_response_model.g.dart';

@JsonSerializable()
class PythonResponseModel {
  final bool profanity;

  PythonResponseModel({
    required this.profanity,
  });

  factory PythonResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PythonResponseModelFromJson(json);
}
