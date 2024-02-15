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
  final String value;
}
