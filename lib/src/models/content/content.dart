import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../parts/parts.dart';
part 'content.freezed.dart';
part 'content.g.dart';

/// [Content] is the value in request response
@unfreezed
class Content with _$Content {
  factory Content({
    List<Parts>? parts,
    String? role,
  }) = _Content;

  factory Content.fromJson(Map<String, Object?> json) =>
      _$ContentFromJson(json);

  static List<Content> jsonToList(List list) =>
      list.map((e) => Content.fromJson(e as Map<String, dynamic>)).toList();
}
