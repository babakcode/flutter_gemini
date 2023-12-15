import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'safety_ratings.freezed.dart';
part 'safety_ratings.g.dart';

@unfreezed
class SafetyRatings with _$SafetyRatings {
  factory SafetyRatings({
    @JsonKey(name: 'category') String? category,
    @JsonKey(name: 'probability') String? probability,
  }) = _SafetyRatings;

  factory SafetyRatings.fromJson(Map<String, Object?> json) =>
      _$SafetyRatingsFromJson(json);

  static List<SafetyRatings> jsonToList(List list) => list
      .map((e) => SafetyRatings.fromJson(e as Map<String, dynamic>))
      .toList();
}
