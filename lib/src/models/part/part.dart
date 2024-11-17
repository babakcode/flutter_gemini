import 'dart:convert';
import 'dart:typed_data';
import 'package:mime/mime.dart' as mime;

part 'text_part.dart';

part 'file_data_part.dart';

part 'file_part.dart';

part 'inline_data.dart';

part 'inline_part.dart';

abstract interface class Part {
  factory Part.text(String text) => TextPart(text);

  factory Part.file(FileDataPart fileData) => FilePart(fileData);

  factory Part.inline(InlineData inlineData) => InlinePart(inlineData);

  factory Part.bytes(Uint8List bytes) =>
      InlinePart(InlineData.fromUint8List(bytes));

  factory Part.uint8List(Uint8List list) =>
      InlinePart(InlineData.fromUint8List(list));

  factory Part.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('file_data')) {
      return Part.file(
          FileDataPart.fromJson(json['file_data'] as Map<String, dynamic>));
    } else if (json.containsKey('inline_data')) {
      return Part.inline(
          InlineData.fromJson(json['inline_data'] as Map<String, dynamic>));
    }

    return Part.text(json['text'] as String);
  }

  static List<Part> jsonToList(List list) =>
      list.map((e) => Part.fromJson(e as Map<String, dynamic>)).toList();

  static Map<String, dynamic> toJson(Part e) {
    if (e is TextPart) {
      return e.toJson();
    } else if (e is FilePart) {
      return e.toJson();
    } else if (e is InlinePart) {
      return e.toJson();
    }

    throw UnsupportedError('${e.runtimeType} not supported!');
  }
}
