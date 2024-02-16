class GeminiException implements Exception {
  /// A message describing the response error.
  final Object message;

  /// http response status code
  final int? statusCode;

  /// [GeminiException] for unexpected errors
  const GeminiException(
    this.message, {
    this.statusCode,
  });

  @override
  String toString() {
    return '**GeminiException** => $message\n\tStatus Code: $statusCode';
  }
}
