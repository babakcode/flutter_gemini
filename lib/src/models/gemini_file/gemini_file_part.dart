class GeminiFilePart {
  String? name;
  String? displayName;
  String? mimeType;
  String? sizeBytes;
  String? createTime;
  String? updateTime;
  String? expirationTime;
  String? sha256Hash;
  String? uri;
  String? state;
  Map<String, dynamic>? error;
  Map<String, dynamic>? videoMetadata;

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

  static List<GeminiFilePart> jsonToList(List list) => list
      .map((e) => GeminiFilePart.fromJson(e as Map<String, dynamic>))
      .toList();
}
