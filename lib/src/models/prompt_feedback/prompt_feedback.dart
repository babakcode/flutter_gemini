import '../safety_ratings/safety_ratings.dart';

/// Represents feedback related to a prompt, specifically focusing on safety ratings.
/// This class holds a list of `SafetyRatings` objects, which evaluate the safety
/// of the generated content based on predefined criteria or custom settings.
///
/// **Parameters:**
/// - `safetyRatings`: A list of `SafetyRatings` objects, which provide an evaluation
///   of the content's safety based on the model's output.
///
/// **Usage:**
/// This class is used to encapsulate feedback on the safety of a generated response.
/// It may include various safety assessments such as whether the content contains
/// harmful or inappropriate material.
///
/// **Example:**
/// ```dart
/// var feedback = PromptFeedback(safetyRatings: [SafetyRatings(...), SafetyRatings(...)]);
/// ```
class PromptFeedback {
  List<SafetyRatings>?
      safetyRatings; // List of safety ratings for the generated content.

  // Constructor to initialize a PromptFeedback instance with optional safetyRatings.
  PromptFeedback({
    this.safetyRatings,
  });

  /// Factory method to create a PromptFeedback instance from JSON data. This method
  /// extracts the `safetyRatings` from the JSON and maps each to a `SafetyRatings` object.
  ///
  /// **Example:**
  /// ```dart
  /// var feedback = PromptFeedback.fromJson(jsonData);
  /// ```
  factory PromptFeedback.fromJson(Map<String, dynamic> json) => PromptFeedback(
        safetyRatings: (json['safetyRatings'] as List<dynamic>?)
            ?.map((e) => SafetyRatings.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  /// Converts the PromptFeedback instance into a JSON map. This is useful for
  /// serializing the feedback to be sent in API requests or responses.
  ///
  /// **Example:**
  /// ```dart
  /// var json = feedback.toJson();
  /// ```
  Map<String, dynamic> toJson() => <String, dynamic>{
        'safetyRatings': safetyRatings,
      };

  /// Converts a list of JSON objects into a list of `PromptFeedback` instances.
  /// This is helpful when handling an array of feedback objects in a JSON response.
  ///
  /// **Example:**
  /// ```dart
  /// var feedbackList = PromptFeedback.jsonToList(jsonList);
  /// ```
  static List<PromptFeedback> jsonToList(List list) => list
      .map((e) => PromptFeedback.fromJson(e as Map<String, dynamic>))
      .toList();
}
