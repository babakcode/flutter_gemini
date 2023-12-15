import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gemini_model.freezed.dart';
part 'gemini_model.g.dart';

@unfreezed
class GeminiModel with _$GeminiModel {
  factory GeminiModel({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'version') String? version,
    @JsonKey(name: 'displayName') String? displayName,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'inputTokenLimit') int? inputTokenLimit,
    @JsonKey(name: 'outputTokenLimit') int? outputTokenLimit,
    @JsonKey(name: 'supportedGenerationMethods')
    List<String>? supportedGenerationMethods,
    @JsonKey(name: 'temperature') double? temperature,
    @JsonKey(name: 'topP') double? topP,
    @JsonKey(name: 'topK') int? topK,
  }) = _GeminiModel;

  factory GeminiModel.fromJson(Map<String, Object?> json) =>
      _$GeminiModelFromJson(json);

  static List<GeminiModel> jsonToList(List list) =>
      list.map((e) => GeminiModel.fromJson(e as Map<String, dynamic>)).toList();
}
