import '../part/part.dart';

class Content {

  List<Part>? parts;
  String? role;

  Content({
    this.parts,
    this.role,
  });

  factory Content.fromJson(Map<String, dynamic> json) =>
      Content(
        parts: (json['parts'] as List?)?.map((e) => Part.fromJson(e)).toList(),
        role: json['role'] as String?,
      );

  static List<Content> jsonToList(List list) =>
      list.map((e) => Content.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'parts': parts?.map((e) => Part.toJson(e)).toList(),
    'role': role,
  };
}
