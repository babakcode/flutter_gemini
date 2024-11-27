part of 'part.dart';

/// Represents an inline part of a request or response, specifically used for
/// handling binary data that is transmitted inline, such as images, audio, or other
/// media types. This class wraps the `InlineData` object, which contains the actual
/// binary content along with its metadata (like MIME type and Base64-encoded data).
///
/// **Parameters:**
/// - `inlineData` (optional InlineData): The inline data associated with this part, typically
///   representing binary data (e.g., an image or file content).
///
/// **Usage:**
/// `InlinePart` is used when the system needs to handle inline data in the form of
/// binary content. It is often used in conjunction with the `Part` interface to represent
/// different types of parts in a larger message (e.g., for multi-part data like in a chat or
/// file upload).
class InlinePart implements Part {
  InlineData?
      inlineData; // The inline data, typically a Base64-encoded file or binary content.

  // Constructor to initialize the InlinePart with the given InlineData.
  InlinePart(this.inlineData);

  /// Converts a list of JSON objects into a list of InlinePart instances.
  /// This is useful for parsing an array of inline parts from a JSON response.
  ///
  /// **Example:**
  /// ```dart
  /// var inlineParts = InlinePart.jsonToList(jsonList);
  /// ```
  static List<InlinePart> jsonToList(List list) =>
      list.map((e) => InlinePart.fromJson(e as Map<String, dynamic>)).toList();

  /// Converts the InlinePart instance into a JSON map. This is used for serializing
  /// the inline part data (including its inline data) to be sent in an API request or
  /// stored in a database.
  ///
  /// **Example:**
  /// ```dart
  /// var jsonData = inlinePart.toJson();
  /// ```
  Map<String, dynamic> toJson() => {
        'inline_data':
            inlineData?.toJson(), // Add inlineData to the JSON map if available
      };

  /// Factory method to create an InlinePart instance from a JSON map.
  /// This is used to deserialize JSON responses containing inline part data.
  ///
  /// **Example:**
  /// ```dart
  /// var inlinePart = InlinePart.fromJson(jsonData);
  /// ```
  factory InlinePart.fromJson(Map<String, dynamic> json) =>
      InlinePart(json['inline_data'] == null
          ? null
          : InlineData.fromJson(
              json['inline_data'])); // Extract inline data from the JSON
}
