part of 'part.dart';

class FileDataPart {
  String? mimeType;
  String? fileUri;

  FileDataPart({this.mimeType, this.fileUri});

  factory FileDataPart.fromJson(Map<String, dynamic> json) =>
      FileDataPart(
        mimeType: json['mime_type'] as String?,
        fileUri: json['file_uri'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'mime_type': mimeType,
    'file_uri': fileUri,
  };
}