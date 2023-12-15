import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../content/content.dart';
import '../safety_ratings/safety_ratings.dart';
part 'candidates.freezed.dart';
part 'candidates.g.dart';

@unfreezed
class Candidates with _$Candidates {
  factory Candidates({
    @JsonKey(name: 'content') Content? content,
    @JsonKey(name: 'finishReason') String? finishReason,
    @JsonKey(name: 'index') int? index,
    @JsonKey(name: 'safetyRatings') List<SafetyRatings>? safetyRatings,
  }) = _Candidates;

  factory Candidates.fromJson(Map<String, Object?> json) =>
      _$CandidatesFromJson(json);

  static List<Candidates> jsonToList(List list) =>
      list.map((e) => Candidates.fromJson(e as Map<String, dynamic>)).toList();
}
