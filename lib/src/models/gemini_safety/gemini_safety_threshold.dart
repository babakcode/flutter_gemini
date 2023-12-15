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
  final String value;
}
