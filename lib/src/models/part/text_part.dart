part of 'part.dart';

class TextPart implements Part{
  String text;

  TextPart(this.text);

  static List<Part> jsonToList(List list) =>
      list.map((e) => Part.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'text': text,
  };
}

