part of 'part.dart';

class InlinePart implements Part {
  InlineData? inlineData;

  InlinePart(this.inlineData);

  static List<InlinePart> jsonToList(List list) =>
      list.map((e) => InlinePart.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {
        'inline_data': inlineData?.toJson(),
      };

  factory InlinePart.fromJson(Map<String, dynamic> json) =>
      InlinePart(json['inline_data'] == null
          ? null
          : InlineData.fromJson(json['inline_data']));
}
