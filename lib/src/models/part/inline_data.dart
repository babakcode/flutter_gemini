part of 'part.dart';

/// Represents inline data used in requests or responses, including metadata like MIME type
/// and the actual data, which is often encoded as a Base64 string. This class is useful for
/// handling in-line binary data such as images, audio files, or any data that needs to be
/// transmitted in the body of a message.
///
/// **Parameters:**
/// - `mimeType` (optional String): The MIME type of the data (e.g., 'image/png', 'application/pdf').
/// - `data` (optional String): The Base64-encoded data representing the binary content.
///
/// **Usage:**
/// `InlineData` is commonly used when binary data needs to be transmitted in a format suitable
/// for text-based protocols (e.g., JSON). It is especially useful for sending media or other
/// non-text data in API requests or responses.
class InlineData {
  String?
      mimeType; // MIME type of the inline data (e.g., 'image/png', 'application/json')
  String? data; // Base64-encoded data representing the file or binary content

  // Constructor to initialize the InlineData with optional mimeType and data
  InlineData({this.mimeType, this.data});

  /// Factory method to create an InlineData instance from a JSON map.
  /// This is used for deserializing JSON responses that contain inline data.
  ///
  /// **Example:**
  /// ```dart
  /// var inlineData = InlineData.fromJson(jsonData);
  /// ```
  factory InlineData.fromJson(Map<String, dynamic> json) => InlineData(
        mimeType: json['mime_type'] as String?, // Extract mimeType from JSON
        data: json['data'] as String?, // Extract Base64-encoded data from JSON
      );

  /// Factory method to create an InlineData instance from raw bytes (Uint8List).
  /// The raw bytes are Base64-encoded, and the MIME type is inferred from the data
  /// using the `mime` package.
  ///
  /// **Example:**
  /// ```dart
  /// var inlineData = InlineData.fromUint8List(bytes);
  /// ```
  factory InlineData.fromUint8List(Uint8List bytes) => InlineData(
        mimeType: mime.lookupMimeType('', headerBytes: bytes) ??
            "image/jpg", // Try to infer MIME type from bytes
        data: base64Encode(bytes), // Encode bytes into Base64 format
      );

  /// Converts the InlineData instance into a JSON map. This method is useful for
  /// serializing the inline data to be sent in an API request or stored.
  ///
  /// **Example:**
  /// ```dart
  /// var jsonData = inlineData.toJson();
  /// ```
  Map<String, dynamic> toJson() => {
        'mime_type': mimeType, // Add mimeType to the JSON map
        'data': data, // Add Base64-encoded data to the JSON map
      };
}
