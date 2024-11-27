import '../../../flutter_gemini.dart';

/// **DEPRECATED**: Please use `Part` instead. This class has been replaced by
/// `Part` for better structure and flexibility in handling different types of
/// content. The `Parts` class was originally designed to hold textual content,
/// but has been superseded by the more general `Part` class, which supports
/// multiple content types, such as text, files, and inline data.
///
/// This class is kept for backward compatibility, but it is recommended to
/// migrate to the `Part` class for future-proofing your code.
///
/// **Parameters:**
/// - `text`: A plain text string that will be included as part of the message.
///
/// **Usage:**
/// The `Parts` class was used for handling plain text content in earlier versions
/// of the package. However, it is now deprecated in favor of the `Part` interface,
/// which supports multiple types of data (e.g., text, files, and bytes).
///
/// **Example:**
/// ```dart
/// var oldPart = Parts(text: 'Some text content');
/// ```
///
@Deprecated('Please use Part instead.')
class Parts implements Part {
  String? text; // The text content that is part of this object.

  // Constructor to initialize the Parts class with optional text.
  Parts({
    this.text,
  });

  /// Factory method to create a Parts instance from JSON data. This was used
  /// to parse plain text content from a JSON object.
  ///
  /// **Example:**
  /// ```dart
  /// var part = Parts.fromJson(jsonData);
  /// ```
  factory Parts.fromJson(Map<String, dynamic> json) =>
      Parts(text: json['text'] as String?);

  /// Converts the Parts instance into a JSON map, serializing the text content
  /// into a structured format for use in API requests or responses.
  ///
  /// **Example:**
  /// ```dart
  /// var json = part.toJson();
  /// ```
  Map<String, dynamic> toJson() => <String, dynamic>{'text': text};

  /// Converts a list of JSON objects into a list of Parts instances.
  /// This was useful when parsing an array of text-based content from a JSON
  /// response.
  ///
  /// **Example:**
  /// ```dart
  /// var partsList = Parts.jsonToList(jsonList);
  /// ```
  static List<Parts> jsonToList(List list) =>
      list.map((e) => Parts.fromJson(e as Map<String, dynamic>)).toList();
}
