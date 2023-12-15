import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../candidates/candidates.dart';
import '../prompt_feedback/prompt_feedback.dart';
part 'gemini_response.freezed.dart';
part 'gemini_response.g.dart';

@unfreezed
class GeminiResponse with _$GeminiResponse {
  factory GeminiResponse({
    @JsonKey(name: 'candidates') List<Candidates>? candidates,
    @JsonKey(name: 'promptFeedback') PromptFeedback? promptFeedback,
  }) = _GeminiResponse;

  factory GeminiResponse.fromJson(Map<String, Object?> json) =>
      _$GeminiResponseFromJson(json);

  static List<GeminiResponse> jsonToList(List list) => list
      .map((e) => GeminiResponse.fromJson(e as Map<String, dynamic>))
      .toList();
}
