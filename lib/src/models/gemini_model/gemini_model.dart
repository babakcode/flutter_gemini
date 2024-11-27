/// Represents the Gemini model with properties such as name, version,
/// description, and token limits, along with configuration for generation
/// methods and sampling parameters.
class GeminiModel {
  /// The name of the model.
  String? name;

  /// The version of the model.
  String? version;

  /// The display name for the model.
  String? displayName;

  /// A description of the model, providing more details about its functionality.
  String? description;

  /// The maximum number of input tokens the model can handle.
  int? inputTokenLimit;

  /// The maximum number of output tokens the model can generate.
  int? outputTokenLimit;

  /// A list of supported generation methods for the model.
  List<String>? supportedGenerationMethods;

  /// The temperature used for controlling the randomness of the model's output.
  /// A value between 0 and 1. Higher values make the output more random.
  double? temperature;

  /// The top-P sampling parameter used to control the diversity of the model's
  /// output. A value between 0 and 1.
  double? topP;

  /// The top-K sampling parameter used to limit the number of possible outputs
  /// considered at each step.
  int? topK;

  /// Constructor to initialize a [GeminiModel] instance with optional values for all fields.
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

  /// Converts a list of JSON objects into a list of [GeminiModel] objects.
  static List<GeminiModel> jsonToList(List list) =>
      list.map((e) => GeminiModel.fromJson(e as Map<String, dynamic>)).toList();

  /// Creates a [GeminiModel] from a JSON object.
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

  /// Converts the current [GeminiModel] object back into a JSON object.
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
