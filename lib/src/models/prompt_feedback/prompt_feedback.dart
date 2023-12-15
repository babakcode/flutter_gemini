import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../safety_ratings/safety_ratings.dart';
part 'prompt_feedback.freezed.dart';
part 'prompt_feedback.g.dart';

@unfreezed
class PromptFeedback with _$PromptFeedback {
  factory PromptFeedback({
    @JsonKey(name: 'safetyRatings') List<SafetyRatings>? safetyRatings,
  }) = _PromptFeedback;

  factory PromptFeedback.fromJson(Map<String, Object?> json) =>
      _$PromptFeedbackFromJson(json);

  static List<PromptFeedback> jsonToList(List list) => list
      .map((e) => PromptFeedback.fromJson(e as Map<String, dynamic>))
      .toList();
}
