// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exception_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExceptionModel _$ExceptionModelFromJson(Map<String, dynamic> json) =>
    ExceptionModel(
      json['code'] as String,
      json['message'] as String,
    );

Map<String, dynamic> _$ExceptionModelToJson(ExceptionModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
