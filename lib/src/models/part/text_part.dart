part of 'part.dart';

/// Represents a text part of a request or response, used for handling plain text
/// content within a message. This class encapsulates the text content, which can
/// be transmitted as part of a multi-part message or response.
///
/// **Parameters:**
/// - `text`: The plain text content that will be included as part of the message.
///
/// **Usage:**
/// `TextPart` is used when the system needs to handle textual data, such as strings,
/// that will be part of a larger message or request. It is commonly used for generating
/// text-based responses or prompts in AI models.
class TextPart implements Part {
  String text;

  /// The text content to be included in this part.

  /// Constructor to initialize the TextPart with the given text content.
  TextPart(this.text);

  /// Converts a list of JSON objects into a list of TextPart instances.
  /// This is useful for parsing an array of text parts from a JSON response.
  ///
  /// **Example:**
  /// ```dart
  /// var textParts = TextPart.jsonToList(jsonList);
  /// ```
  static List<Part> jsonToList(List list) =>
      list.map((e) => Part.fromJson(e as Map<String, dynamic>)).toList();

  /// Converts the TextPart instance into a JSON map. This is used for serializing
  /// the text content to be sent in an API request or stored in a database.
  ///
  /// **Example:**
  /// ```dart
  /// var jsonData = textPart.toJson();
  /// ```
  Map<String, dynamic> toJson() => {
        'text': text, // Add text content to the JSON map
      };
}
