import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generation_config.freezed.dart';
part 'generation_config.g.dart';

@unfreezed
class GenerationConfig with _$GenerationConfig {
  factory GenerationConfig({
    @JsonKey(name: 'stopSequences') List<String>? stopSequences,
    @JsonKey(name: 'temperature') double? temperature,
    @JsonKey(name: 'maxOutputTokens') int? maxOutputTokens,
    @JsonKey(name: 'topP') double? topP,
    @JsonKey(name: 'topK') int? topK,
  }) = _GenerationConfig;

  factory GenerationConfig.fromJson(Map<String, Object?> json) =>
      _$GenerationConfigFromJson(json);

  static List<GenerationConfig> jsonToList(List list) => list
      .map((e) => GenerationConfig.fromJson(e as Map<String, dynamic>))
      .toList();
}
