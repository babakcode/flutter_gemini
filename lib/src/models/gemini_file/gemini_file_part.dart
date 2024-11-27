/// Represents a file part in the Gemini system with metadata like name, size,
/// state, and additional details such as error information and video metadata.
class GeminiFilePart {
  /// The name of the file.
  String? name;

  /// The display name of the file.
  String? displayName;

  /// The MIME type of the file.
  String? mimeType;

  /// The size of the file in bytes.
  String? sizeBytes;

  /// The creation time of the file.
  String? createTime;

  /// The last update time of the file.
  String? updateTime;

  /// The expiration time of the file.
  String? expirationTime;

  /// The SHA256 hash of the file for integrity verification.
  String? sha256Hash;

  /// The URI pointing to the location of the file.
  String? uri;

  /// The current state of the file.
  String? state;

  /// Any error information associated with the file, if applicable.
  Map<String, dynamic>? error;

  /// Metadata related to video files, if applicable.
  Map<String, dynamic>? videoMetadata;

  /// Constructor to initialize a [GeminiFilePart] instance with optional values for all fields.
  GeminiFilePart({
    this.name,
    this.displayName,
    this.mimeType,
    this.sizeBytes,
    this.createTime,
    this.updateTime,
    this.expirationTime,
    this.sha256Hash,
    this.uri,
    this.state,
    this.error,
    this.videoMetadata,
  });

  /// Creates a [GeminiFilePart] from a JSON object.
  factory GeminiFilePart.fromJson(Map<String, dynamic> json) => GeminiFilePart(
        name: json['name'] as String?,
        displayName: json['displayName'] as String?,
        mimeType: json['mimeType'] as String?,
        sizeBytes: json['sizeBytes'] as String?,
        createTime: json['createTime'] as String?,
        updateTime: json['updateTime'] as String?,
        expirationTime: json['expirationTime'] as String?,
        sha256Hash: json['sha256Hash'] as String?,
        uri: json['uri'] as String?,
        state: json['state'] as String?,
        error: json['error'] as Map<String, dynamic>?,
        videoMetadata: json['videoMetadata'] as Map<String, dynamic>?,
      );

  /// Converts the current [GeminiFilePart] object back into a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'displayName': displayName,
        'mimeType': mimeType,
        'sizeBytes': sizeBytes,
        'createTime': createTime,
        'updateTime': updateTime,
        'expirationTime': expirationTime,
        'sha256Hash': sha256Hash,
        'uri': uri,
        'state': state,
        'error': error,
        'videoMetadata': videoMetadata,
      };

  /// Converts a list of JSON objects into a list of [GeminiFilePart] objects.
  static List<GeminiFilePart> jsonToList(List list) => list
      .map((e) => GeminiFilePart.fromJson(e as Map<String, dynamic>))
      .toList();
}
