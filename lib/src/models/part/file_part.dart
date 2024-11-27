part of 'part.dart';

/// Represents a part of a request or response that contains file data. This class implements
/// the `Part` interface and is used when a file is included in the conversation, allowing
/// for seamless handling of file-based content alongside other parts such as text or inline data.
///
/// **Parameters:**
/// - `fileData` (optional FileDataPart): Contains the actual file data and associated metadata,
///   such as MIME type and file URI.
///
/// **Usage:**
/// `FilePart` is used when you need to send or receive file data as part of an API request or
/// response. It encapsulates the file-related information within the context of a larger content
/// structure, like a conversation or message.
class FilePart implements Part {
  FileDataPart?
      fileData; // The file data and its associated metadata (e.g., mimeType, fileUri)

  // Constructor for initializing the FilePart with a FileDataPart
  FilePart(this.fileData);

  /// Converts a list of JSON objects into a list of FilePart instances.
  /// This is useful for deserializing a response that contains multiple file parts.
  ///
  /// **Example:**
  /// ```dart
  /// var filePartsList = FilePart.jsonToList(jsonList);
  /// ```
  static List<FilePart> jsonToList(List list) =>
      list.map((e) => FilePart.fromJson(e as Map<String, dynamic>)).toList();

  /// Converts the FilePart instance into a JSON map. This is used when serializing
  /// the FilePart to be sent as part of an API request or saving it to storage.
  ///
  /// **Example:**
  /// ```dart
  /// var jsonData = filePart.toJson();
  /// ```
  Map<String, dynamic> toJson() => {
        'fileData':
            fileData?.toJson(), // Serialize fileData to JSON if available
      };

  /// Factory method to create a FilePart instance from a JSON map. This is used for
  /// deserializing a JSON response that includes a file part.
  ///
  /// **Example:**
  /// ```dart
  /// var filePart = FilePart.fromJson(jsonData);
  /// ```
  factory FilePart.fromJson(Map<String, dynamic> json) =>
      FilePart(json['file_data'] == null
          ? null
          : FileDataPart.fromJson(json['file_data'])); // Deserialize file data
}
