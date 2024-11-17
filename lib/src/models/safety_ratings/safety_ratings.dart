
class SafetyRatings {
  String? category;
      String? probability;

  SafetyRatings({
    this.category,
    this.probability,
  });

  factory SafetyRatings.fromJson(Map<String, dynamic> json) =>
      SafetyRatings(
        category: json['category'] as String?,
        probability: json['probability'] as String?,
      );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'category': category,
        'probability': probability,
      };

  static List<SafetyRatings> jsonToList(List list) => list
      .map((e) => SafetyRatings.fromJson(e as Map<String, dynamic>))
      .toList();
}
