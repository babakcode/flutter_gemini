import 'dart:convert';
import 'dart:typed_data';
import 'package:mime/mime.dart' as mime;

part 'text_part.dart';

part 'file_data_part.dart';

part 'file_part.dart';

part 'inline_data.dart';

part 'inline_part.dart';

/// Represents a flexible data part that can hold text, file, or binary data.
/// This is an abstract interface class with factory constructors for specific
/// implementations like `TextPart`, `FilePart`, and `InlinePart`.
abstract interface class Part {
  /// Factory constructor to create a `Part` object containing text data.
  factory Part.text(String text) => TextPart(text);

  /// Factory constructor to create a `Part` object containing file data.
  factory Part.file(FileDataPart fileData) => FilePart(fileData);

  /// Factory constructor to create a `Part` object containing inline binary data.
  factory Part.inline(InlineData inlineData) => InlinePart(inlineData);

  /// Factory constructor to create a `Part` object from raw binary data.
  factory Part.bytes(Uint8List bytes) =>
      InlinePart(InlineData.fromUint8List(bytes));

  /// Factory constructor to create a `Part` object from a `Uint8List`.
  factory Part.uint8List(Uint8List list) =>
      InlinePart(InlineData.fromUint8List(list));

  /// Factory constructor to create a `Part` object from a JSON object.
  /// Automatically detects the part type based on the keys in the JSON.
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

  /// Converts a JSON list into a list of `Part` objects.
  static List<Part> jsonToList(List list) =>
      list.map((e) => Part.fromJson(e as Map<String, dynamic>)).toList();

  /// Converts the `Part` object to a JSON object, automatically identifying
  /// its specific type (`TextPart`, `FilePart`, or `InlinePart`).
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
