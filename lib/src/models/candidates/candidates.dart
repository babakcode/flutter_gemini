import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../content/content.dart';
import '../safety_ratings/safety_ratings.dart';
part 'candidates.freezed.dart';
part 'candidates.g.dart';

/// [Candidates] is the value in request response
@unfreezed
class Candidates with _$Candidates {
  factory Candidates({
    Content? content,
    String? finishReason,
    int? index,
    List<SafetyRatings>? safetyRatings,
  }) = _Candidates;

  factory Candidates.fromJson(Map<String, Object?> json) =>
      _$CandidatesFromJson(json);

  static List<Candidates> jsonToList(List list) =>
      list.map((e) => Candidates.fromJson(e as Map<String, dynamic>)).toList();
}
