class GenerationConfig {
  List<String>? stopSequences;
  double? temperature;
  int? maxOutputTokens;
  double? topP;
  int? topK;

  GenerationConfig({
    this.stopSequences,
    this.temperature,
    this.maxOutputTokens,
    this.topP,
    this.topK,
  });

  factory GenerationConfig.fromJson(Map<String, dynamic> json) =>
      GenerationConfig(
        stopSequences: (json['stopSequences'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        temperature: (json['temperature'] as num?)?.toDouble(),
        maxOutputTokens: (json['maxOutputTokens'] as num?)?.toInt(),
        topP: (json['topP'] as num?)?.toDouble(),
        topK: (json['topK'] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'stopSequences': stopSequences,
        'temperature': temperature,
        'maxOutputTokens': maxOutputTokens,
        'topP': topP,
        'topK': topK,
      };

  static List<GenerationConfig> jsonToList(List list) => list
      .map((e) => GenerationConfig.fromJson(e as Map<String, dynamic>))
      .toList();
}
