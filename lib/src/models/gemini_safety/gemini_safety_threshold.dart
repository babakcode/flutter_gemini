/// An enumeration representing various safety thresholds for content moderation.
/// Each threshold defines a level of risk associated with potentially unsafe content,
/// dictating whether content should be blocked or flagged based on its probability of being harmful.
///
/// **Enum Values:**
/// - `blockNone`: Content is always shown, regardless of the probability of unsafe content.
/// - `blockOnlyHigh`: Content is blocked only if there is a high probability of unsafe content.
/// - `blockMediumAndAbove`: Content is blocked if there is a medium or high probability of unsafe content.
/// - `blockLowAndAbove`: Content is blocked if there is a low, medium, or high probability of unsafe content.
/// - `harmBlockThresholdUnspecified`: The threshold is unspecified, and the system uses a default block threshold.
///
/// **Usage:**
/// The `SafetyThreshold` enum is used to configure how strict the moderation system should be when evaluating content. Depending on the chosen threshold, content with varying levels of unsafe probability can be blocked or allowed.
///
/// **Example:**
/// ```dart
/// var safetySetting = SafetySetting(
///   category: SafetyCategory.dangerous,     // Flag dangerous content.
///   threshold: SafetyThreshold.blockMediumAndAbove, // Block if content has medium or high risk.
/// );
/// ```
enum SafetyThreshold {
  /// [blockNone]
  /// Always show regardless of probability of unsafe content
  blockNone('BLOCK_NONE'),

  /// [blockOnlyHigh]
  /// Block when high probability of unsafe content
  blockOnlyHigh('BLOCK_ONLY_HIGH'),

  /// [blockMediumAndAbove]
  /// Block when medium or high probability of unsafe content
  blockMediumAndAbove('BLOCK_MEDIUM_AND_ABOVE'),

  /// [blockLowAndAbove]
  /// Block when low, medium or high probability of unsafe content
  blockLowAndAbove('BLOCK_LOW_AND_ABOVE'),

  /// [harmBlockThresholdUnspecified]
  /// Threshold is unspecified, block using default threshold
  harmBlockThresholdUnspecified('HARM_BLOCK_THRESHOLD_UNSPECIFIED');

  const SafetyThreshold(this.value);

  /// The string value that represents the safety threshold for backend processing or API use.
  final String value;
}
