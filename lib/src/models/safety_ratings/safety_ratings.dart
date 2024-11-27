/// Represents a safety rating for generated content, which includes a category and
/// a probability score. The category indicates the type of safety issue (e.g.,
/// harmful, inappropriate), and the probability is a confidence score indicating
/// how likely the content falls into that category.
///
/// **Parameters:**
/// - `category`: The category of the safety rating (e.g., "Harmful", "Inappropriate").
/// - `probability`: The probability or confidence level that the content falls under
///   the specified safety category (expressed as a string, often a percentage or score).
///
/// **Usage:**
/// This class is used to evaluate the safety of AI-generated content. For example,
/// a system could generate content and then evaluate its safety with respect to various
/// categories such as offensive language, harmful behavior, or misleading information.
///
/// **Example:**
/// ```dart
/// var safetyRating = SafetyRatings(category: "Harmful", probability: "0.85");
/// print(safetyRating.category); // Outputs: Harmful
/// ```
class SafetyRatings {
  String? category; // The safety category (e.g., "Harmful", "Offensive").
  String?
      probability; // The probability score indicating how likely the content is harmful.

  // Constructor to initialize a SafetyRatings instance with optional category and probability.
  SafetyRatings({
    this.category,
    this.probability,
  });

  /// Factory method to create a SafetyRatings instance from JSON data.
  /// It extracts the `category` and `probability` fields from the JSON and assigns them
  /// to the class's properties.
  ///
  /// **Example:**
  /// ```dart
  /// var safetyRating = SafetyRatings.fromJson(jsonData);
  /// ```
  factory SafetyRatings.fromJson(Map<String, dynamic> json) => SafetyRatings(
        category: json['category'] as String?,
        probability: json['probability'] as String?,
      );

  /// Converts the SafetyRatings instance into a JSON map. This is useful for
  /// serializing the safety rating to be sent in API requests or responses.
  ///
  /// **Example:**
  /// ```dart
  /// var json = safetyRating.toJson();
  /// ```
  Map<String, dynamic> toJson() => <String, dynamic>{
        'category': category,
        'probability': probability,
      };

  /// Converts a list of JSON objects into a list of `SafetyRatings` instances.
  /// This is helpful when handling an array of safety ratings in a JSON response.
  ///
  /// **Example:**
  /// ```dart
  /// var safetyRatingsList = SafetyRatings.jsonToList(jsonList);
  /// ```
  static List<SafetyRatings> jsonToList(List list) => list
      .map((e) => SafetyRatings.fromJson(e as Map<String, dynamic>))
      .toList();
}
