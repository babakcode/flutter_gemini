part of 'part.dart';

class FilePart implements Part{
  FileDataPart? fileData;

  FilePart(this.fileData);

  static List<FilePart> jsonToList(List list) =>
      list.map((e) => FilePart.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'fileData': fileData?.toJson(),
  };

  factory FilePart.fromJson(Map<String, dynamic> json) =>
      FilePart(json['file_data'] == null ? null : FileDataPart.fromJson(json['file_data']));
}

