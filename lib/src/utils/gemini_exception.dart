/// A custom exception class to represent errors that occur during Gemini API interactions.
/// This exception is used to capture error messages and status codes from the API response,
/// providing more context for error handling.
///
/// **Usage:**
/// You can throw a `GeminiException` when an API request fails or encounters an unexpected issue.
///
/// **Example:**
/// ```dart
/// if (response.statusCode != 200) {
///   throw GeminiException('Failed to fetch data', statusCode: response.statusCode);
/// }
/// ```
class GeminiException implements Exception {
  /// A message describing the error that occurred. This can be a string or any other object
  /// containing details about the error (e.g., error description, API message).
  final Object message;

  /// The HTTP response status code from the API request. It provides context for the error,
  /// such as whether it was a client error (4xx) or server error (5xx).
  final int? statusCode;

  /// Constructs a [GeminiException] with an error message and optional status code.
  ///
  /// **Parameters:**
  /// - `message` (Object): The message describing the error.
  /// - `statusCode` (int?, optional): The HTTP status code associated with the error (e.g., 404, 500).
  const GeminiException(
    this.message, {
    this.statusCode,
  });

  @override
  String toString() {
    // Returns a string representation of the exception, including the error message and status code.
    return '**GeminiException** => $message\n\tStatus Code: $statusCode';
  }
}
