part of 'part.dart';

/// Represents a part of a file, including metadata like MIME type and URI pointing to the file.
/// This class is used when a file is included in the conversation or request, allowing the system
/// to handle files alongside other content types (such as text or inline data).
///
/// **Parameters:**
/// - `mimeType` (optional String): The MIME type of the file (e.g., 'image/png', 'application/pdf').
/// - `fileUri` (optional String): The URI pointing to the location of the file.
///
/// **Usage:**
/// The `FileDataPart` is typically used when you need to send or process file data as part of a request.
/// It contains the necessary information to identify and handle the file correctly, such as its type
/// and location. For example, it can be used in chat-based applications where users send files.
class FileDataPart {
  String? mimeType; // The MIME type of the file (e.g., image/jpeg, text/plain)
  String? fileUri; // The URI of the file, which points to its location.

  // Constructor for initializing the FileDataPart with optional mimeType and fileUri
  FileDataPart({this.mimeType, this.fileUri});

  /// Factory method to create a FileDataPart object from a JSON map.
  /// This is useful for deserializing a JSON response that includes file data.
  ///
  /// **Example:**
  /// ```dart
  /// var fileDataPart = FileDataPart.fromJson(jsonData);
  /// ```
  factory FileDataPart.fromJson(Map<String, dynamic> json) => FileDataPart(
        mimeType: json['mime_type'] as String?, // Extract mimeType from JSON
        fileUri: json['file_uri'] as String?, // Extract fileUri from JSON
      );

  /// Converts the FileDataPart object into a JSON map, which can be used for serializing the data.
  /// This is useful for sending file data in API requests or saving it in a file format.
  ///
  /// **Example:**
  /// ```dart
  /// var jsonData = fileDataPart.toJson();
  /// ```
  Map<String, dynamic> toJson() => {
        'mime_type': mimeType, // Add mimeType to JSON map
        'file_uri': fileUri, // Add fileUri to JSON map
      };
}
