/// Configuration for controlling the behavior of content generation,
/// including various parameters such as stop sequences, temperature, and token limits.
///
/// **Parameters:**
/// - `stopSequences`: A list of strings that the model should stop generating upon encountering.
/// - `temperature`: A floating-point value that controls the randomness of the output.
///   A higher temperature makes the output more random, while a lower temperature makes it more deterministic.
/// - `maxOutputTokens`: The maximum number of tokens the model should generate in its response.
/// - `topP`: A parameter used for nucleus sampling. It controls the cumulative probability distribution
///   from which the model samples, helping to make the output more diverse.
/// - `topK`: The number of highest probability tokens to consider during sampling.
///
/// **Usage:**
/// This class is used to define and configure the generation behavior of a model when generating text or content.
/// It allows customization of parameters that control the creativity and structure of the generated output.
///
/// **Example:**
/// ```dart
/// var config = GenerationConfig(
///   stopSequences: ['\n'],
///   temperature: 0.7,
///   maxOutputTokens: 100,
/// );
/// ```
class GenerationConfig {
  List<String>? stopSequences; // A list of stop sequences to halt generation.
  double? temperature; // A value between 0 and 1 controlling output randomness.
  int? maxOutputTokens; // Maximum number of tokens to be generated.
  double? topP; // Nucleus sampling parameter.
  int? topK; // The number of top tokens to sample from.

  // Constructor to initialize the GenerationConfig instance with optional parameters.
  GenerationConfig({
    this.stopSequences,
    this.temperature,
    this.maxOutputTokens,
    this.topP,
    this.topK,
  });

  /// Factory method to create a GenerationConfig instance from JSON data.
  /// It converts JSON fields like `stopSequences`, `temperature`, `maxOutputTokens`,
  /// `topP`, and `topK` to their corresponding properties in the `GenerationConfig` class.
  ///
  /// **Example:**
  /// ```dart
  /// var config = GenerationConfig.fromJson(jsonData);
  /// ```
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

  /// Converts the GenerationConfig instance into a JSON map. This is useful for
  /// serializing the configuration to be sent in API requests or stored in a database.
  ///
  /// **Example:**
  /// ```dart
  /// var json = config.toJson();
  /// ```
  Map<String, dynamic> toJson() => <String, dynamic>{
        'stopSequences': stopSequences,
        'temperature': temperature,
        'maxOutputTokens': maxOutputTokens,
        'topP': topP,
        'topK': topK,
      };

  /// Converts a list of JSON objects into a list of `GenerationConfig` instances.
  /// This is helpful when handling an array of generation configurations in a JSON response.
  ///
  /// **Example:**
  /// ```dart
  /// var configsList = GenerationConfig.jsonToList(jsonList);
  /// ```
  static List<GenerationConfig> jsonToList(List list) => list
      .map((e) => GenerationConfig.fromJson(e as Map<String, dynamic>))
      .toList();
}
