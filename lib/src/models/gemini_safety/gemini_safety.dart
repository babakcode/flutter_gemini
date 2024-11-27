import 'gemini_safety_category.dart';
import 'gemini_safety_threshold.dart';

/// [SafetySetting]
/// Safety settings are part of the request you send to the text service.
/// It can be adjusted for each request you make to the API.
/// The following table lists the categories that you can set and describes the type of harm that each category encompasses.
/// A configuration for setting safety measures, including a category and threshold.
/// This class helps define the safety parameters to assess or control the behavior of the AI model's outputs.
///
/// **Parameters:**
/// - `category`: The safety category that specifies the type of content safety being controlled (e.g., toxic content, explicit material).
/// - `threshold`: The threshold for safety within the specified category. This defines the level at which the content is considered unsafe or acceptable.
///
/// **Usage:**
/// This class is used when you want to specify the level of safety to be applied during content generation or filtering. It can be used in AI systems to enforce content moderation, ensuring that the generated content adheres to certain safety standards.
///
/// **Example:**
/// ```dart
/// var safetySetting = SafetySetting(
///   category: SafetyCategory.explosive,
///   threshold: SafetyThreshold.high,
/// );
/// ```
class SafetySetting {
  final SafetyCategory
      category; // The category of safety being controlled (e.g., toxic content).
  final SafetyThreshold
      threshold; // The threshold for safety within the category.

  // Constructor to initialize the SafetySetting with required category and threshold.
  SafetySetting({
    required this.category,
    required this.threshold,
  });
}
