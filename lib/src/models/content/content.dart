import '../part/part.dart';

/// Represents the content of an AI response, including its components (parts)
/// and the role associated with it, such as "user" or "model".
class Content {
  /// A list of `Part` objects that make up the content. Each `Part` can
  /// represent text, files, or binary data.
  List<Part>? parts;

  /// The role associated with this content, indicating who or what generated
  /// the content (e.g., "model" or "user").
  String? role;

  /// Creates a new `Content` object with optional parts and role.
  Content({
    this.parts,
    this.role,
  });

  /// Factory constructor to create a `Content` instance from a JSON object.
  factory Content.fromJson(Map<String, dynamic> json) => Content(
        parts: (json['parts'] as List?)
            ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
            .toList(),
        role: json['role'] as String?,
      );

  /// Converts a JSON list into a list of `Content` objects.
  static List<Content> jsonToList(List list) =>
      list.map((e) => Content.fromJson(e as Map<String, dynamic>)).toList();

  /// Converts the `Content` object to a JSON object.
  Map<String, dynamic> toJson() => {
        'parts': parts?.map((e) => Part.toJson(e)).toList(),
        'role': role,
      };
}
