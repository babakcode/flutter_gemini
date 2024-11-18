class GeminiModel {
  String? name;
  String? version;
  String? displayName;
  String? description;
  int? inputTokenLimit;
  int? outputTokenLimit;
  List<String>? supportedGenerationMethods;
  double? temperature;
  double? topP;
  int? topK;

  GeminiModel({
    this.name,
    this.version,
    this.displayName,
    this.description,
    this.inputTokenLimit,
    this.outputTokenLimit,
    this.supportedGenerationMethods,
    this.temperature,
    this.topP,
    this.topK,
  });

  static List<GeminiModel> jsonToList(List list) =>
      list.map((e) => GeminiModel.fromJson(e as Map<String, dynamic>)).toList();

  factory GeminiModel.fromJson(Map<String, dynamic> json) => GeminiModel(
        name: json['name'] as String?,
        version: json['version'] as String?,
        displayName: json['displayName'] as String?,
        description: json['description'] as String?,
        inputTokenLimit: (json['inputTokenLimit'] as num?)?.toInt(),
        outputTokenLimit: (json['outputTokenLimit'] as num?)?.toInt(),
        supportedGenerationMethods:
            (json['supportedGenerationMethods'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList(),
        temperature: (json['temperature'] as num?)?.toDouble(),
        topP: (json['topP'] as num?)?.toDouble(),
        topK: (json['topK'] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'version': version,
        'displayName': displayName,
        'description': description,
        'inputTokenLimit': inputTokenLimit,
        'outputTokenLimit': outputTokenLimit,
        'supportedGenerationMethods': supportedGenerationMethods,
        'temperature': temperature,
        'topP': topP,
        'topK': topK,
      };
}
