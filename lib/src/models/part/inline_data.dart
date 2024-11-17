
part of 'part.dart';

class InlineData {
  String? mimeType;
  String? data;

  InlineData({this.mimeType, this.data});

  factory InlineData.fromJson(Map<String, dynamic> json) =>
      InlineData(
        mimeType: json['mime_type'] as String?,
        data: json['data'] as String?,
      );

  factory InlineData.fromUint8List(Uint8List bytes) =>
      InlineData(
        mimeType: mime.lookupMimeType('', headerBytes: bytes) ?? "image/jpg",
        data: base64Encode(bytes),
      );

  Map<String, dynamic> toJson() => {
    'mime_type': mimeType,
    'data': data,
  };
}

