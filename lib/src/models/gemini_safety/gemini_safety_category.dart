/// An enumeration representing various safety categories for content moderation.
/// Each category corresponds to a type of potentially harmful content that can be flagged,
/// restricted, or filtered based on specific safety settings.
///
/// **Enum Values:**
/// - `harassment`: Content that involves negative or harmful comments targeting someone's identity, protected attributes, or groups.
/// - `hateSpeech`: Content that is rude, offensive, or profane. Includes derogatory, dehumanizing, or discriminatory language.
/// - `sexuallyExplicit`: Content that includes sexual acts or other sexually suggestive material.
/// - `dangerous`: Content that promotes, encourages, or facilitates harmful or dangerous actions, such as violence, self-harm, etc.
///
/// **Usage:**
/// The `SafetyCategory` enum is used as part of content moderation or filtering systems to ensure that AI-generated content adheres to safety standards. When setting up safety measures, users can select the appropriate category to monitor or control content in a more focused way.
///
/// **Example:**
/// ```dart
/// var safetySetting = SafetySetting(
///   category: SafetyCategory.hateSpeech,  // Flag hate speech content.
///   threshold: SafetyThreshold.high,      // Apply a high-level safety threshold.
/// );
/// ```
enum SafetyCategory {
  /// [harassment]
  /// Negative or harmful comments targeting identity and/or protected attributes.
  harassment('HARM_CATEGORY_HARASSMENT'),

  /// [hateSpeech]
  /// Content that is rude, disrespectful, or profane.
  hateSpeech('HARM_CATEGORY_HATE_SPEECH'),

  /// [sexuallyExplicit]
  /// Contains references to sexual acts or other lewd content.
  sexuallyExplicit('HARM_CATEGORY_SEXUALLY_EXPLICIT'),

  /// [dangerous]
  /// Promotes, facilitates, or encourages harmful acts.
  dangerous('HARM_CATEGORY_DANGEROUS_CONTENT');

  const SafetyCategory(this.value);

  /// The string value that represents the safety category for backend processing or API use.
  final String value;
}
