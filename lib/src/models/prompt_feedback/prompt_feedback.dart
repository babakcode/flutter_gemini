import '../safety_ratings/safety_ratings.dart';

class PromptFeedback {
  List<SafetyRatings>? safetyRatings;

  PromptFeedback({
    this.safetyRatings,
  });

  factory PromptFeedback.fromJson(Map<String, dynamic> json) => PromptFeedback(
        safetyRatings: (json['safetyRatings'] as List<dynamic>?)
            ?.map((e) => SafetyRatings.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'safetyRatings': safetyRatings,
      };

  static List<PromptFeedback> jsonToList(List list) => list
      .map((e) => PromptFeedback.fromJson(e as Map<String, dynamic>))
      .toList();
}
