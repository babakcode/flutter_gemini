import '../../../flutter_gemini.dart';

class Parts implements Part{
  String? text;

  Parts({
    this.text,
  });

  factory Parts.fromJson(Map<String, dynamic> json) =>
      Parts(text: json['text'] as String?);

  Map<String, dynamic> toJson() => <String, dynamic>{'text': text};

  static List<Parts> jsonToList(List list) =>
      list.map((e) => Parts.fromJson(e as Map<String, dynamic>)).toList();
}
