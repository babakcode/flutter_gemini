import '../content/content.dart';
import '../safety_ratings/safety_ratings.dart';

/// [Candidates] is the value in request response
class Candidates {
  Content? content;
  String? finishReason;
  int? index;
  List<SafetyRatings>? safetyRatings;

  Candidates({
    this.content,
    this.finishReason,
    this.index,
    this.safetyRatings,
  });

  factory Candidates.fromJson(Map<String, dynamic> json) {
    return Candidates(
      content: json['content'] == null
          ? null
          : Content.fromJson(json['content'] as Map<String, dynamic>),
      finishReason: json['finishReason'] as String?,
      index: (json['index'] as num?)?.toInt(),
      safetyRatings: (json['safetyRatings'] as List<dynamic>?)
          ?.map((e) => SafetyRatings.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> json) => {
        'content': content?.toJson(),
        'finishReason': finishReason,
        'index': index,
        'safetyRatings': safetyRatings?.map((e) => e.toJson()).toList(),
      };

  Candidates copyWith(
    Content? content,
    String? finishReason,
    int? index,
    List<SafetyRatings>? safetyRatings,
  ) =>
      Candidates(
        safetyRatings: safetyRatings ?? this.safetyRatings,
        index: index ?? this.index,
        finishReason: finishReason ?? this.finishReason,
        content: content ?? this.content,
      );

  static List<Candidates> jsonToList(List list) =>
      list.map((e) => Candidates.fromJson(e as Map<String, dynamic>)).toList();
}
