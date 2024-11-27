import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_gemini/src/models/candidates/candidates.dart';
import 'package:flutter_gemini/src/models/part/part.dart';
import 'config/constants.dart';
import 'implement/gemini_service.dart';
import 'models/content/content.dart';
import 'models/gemini_model/gemini_model.dart';
import 'models/generation_config/generation_config.dart';
import 'repository/gemini_interface.dart';
import 'package:dio/dio.dart';
import 'implement/gemini_implement.dart';
import 'models/gemini_safety/gemini_safety.dart';

/// [Gemini]
/// Flutter Google Gemini SDK. Google Gemini is a set of cutting-edge large language models
///   (LLMs) designed to be the driving force behind Google's future AI initiatives.
///   implements [GeminiInterface]
///   and [GeminiInterface] defines all methods of Gemini
///   Here's a simple example of using this API:
///
/// ```dart
/// const apiKey = 'AIza...';
///
/// void main() async {
///   Gemini.init(apiKey: apiKey);
///   final prompt = Gemini.instance.prompt(parts: [
///     Part.text('Write a story about a magic backpack.'),
///   ]);
///   print(prompt?.output);
/// }
/// ```
class Gemini implements GeminiInterface {
  /// [enableDebugging]
  /// to see request progress
  static bool? enableDebugging = false;

  /// Private constructor for initializing the Gemini instance. This constructor
  /// is used internally to configure the Gemini service with the necessary API key,
  /// optional configuration settings, and safety options.
  ///
  /// **Parameters:**
  /// - `apiKey` (required String): The API key required to authenticate requests.
  /// - `baseURL` (optional String): The base URL for the API, defaults to a predefined constant if not provided.
  /// - `headers` (optional Map<String, dynamic>): Custom headers to include in the API requests.
  /// - `safetySettings` (optional List<SafetySetting>): Optional safety settings to apply to the API requests.
  /// - `generationConfig` (optional GenerationConfig): Configuration related to text generation, such as model parameters.
  /// - `version` (optional String): The API version to use. Defaults to a predefined constant if not provided.
  /// - `disableAutoUpdateModelName` (optional bool, default false): Flag to disable auto-updating of the model name.
  Gemini._({
    /// [apiKey] is required property
    required String apiKey,
    String? baseURL,
    Map<String, dynamic>? headers,

    /// theses properties are optional
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
    String? version,
    this.disableAutoUpdateModelName = false,
  }) : _impl = GeminiImpl(
          api: GeminiService(
              Dio(BaseOptions(
                baseUrl:
                    '${baseURL ?? Constants.baseUrl}${version ?? Constants.defaultVersion}/',
                contentType: 'application/json',
                headers: headers,
              )),
              apiKey: apiKey),
          safetySettings: safetySettings,
          generationConfig: generationConfig,
        );

  /// singleton [instance] from main [Gemini] class
  static late Gemini instance;
  static bool _firstInit = true;

  /// initial properties
  ///  - [_impl] functions logic
  GeminiImpl _impl;

  /// [Gemini]
  /// Flutter Google Gemini SDK. Google Gemini is a set of cutting-edge large language models
  ///   (LLMs) designed to be the driving force behind Google's future AI initiatives.
  ///   implements [GeminiInterface]
  ///   and [GeminiInterface] defines all methods of Gemini
  ///   Here's a simple example of using this API:
  ///
  /// ```dart
  /// const apiKey = 'AIza...';
  ///
  /// void main() async {
  ///   Gemini.init(apiKey: apiKey);
  ///   final prompt = Gemini.instance.prompt(parts: [
  ///     Part.text('Write a story about a magic backpack.'),
  ///   ]);
  ///   print(prompt?.output);
  /// }
  /// ```
  /// /// Factory method to initialize and return a singleton instance of `Gemini`.
  /// This method is used to configure and initialize the Gemini instance for the first time.
  /// It ensures that only one instance of `Gemini` is created throughout the lifecycle of the application.
  ///
  /// **Parameters:**
  /// - `apiKey` (required String): The API key for authenticating requests.
  /// - `baseURL` (optional String): The base URL for the API.
  /// - `headers` (optional Map<String, dynamic>): Custom headers for API requests.
  /// - `safetySettings` (optional List<SafetySetting>): Safety settings to configure content filtering.
  /// - `generationConfig` (optional GenerationConfig): Configuration for text generation.
  /// - `enableDebugging` (optional bool): Flag to enable debugging (logs, verbose output).
  /// - `version` (optional String): The API version to use.
  /// - `disableAutoUpdateModelName` (default false): Flag to disable automatic model name updates.
  factory Gemini.init({
    required String apiKey,
    String? baseURL,
    Map<String, dynamic>? headers,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
    bool? enableDebugging,
    String? version,
    bool disableAutoUpdateModelName = false,
  }) {
    Gemini.enableDebugging = enableDebugging;
    if (_firstInit) {
      _firstInit = false;
      instance = Gemini._(
        apiKey: apiKey,
        baseURL: baseURL,
        headers: headers,
        safetySettings: safetySettings,
        generationConfig: generationConfig,
        version: version,
        disableAutoUpdateModelName: disableAutoUpdateModelName,
      );
    }
    return instance;
  }

  factory Gemini.reInitialize({
    required String apiKey,
    String? baseURL,
    Map<String, dynamic>? headers,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
    bool? enableDebugging,
    String? version,
    bool disableAutoUpdateModelName = false,
  }) {
    Gemini.enableDebugging = enableDebugging;
    instance = Gemini._(
      apiKey: apiKey,
      baseURL: baseURL,
      headers: headers,
      safetySettings: safetySettings,
      generationConfig: generationConfig,
      version: version,
      disableAutoUpdateModelName: disableAutoUpdateModelName,
    );
    return instance;
  }

  /// Facilitates a chat interaction by processing a list of `Content` objects
  /// (representing chat messages) and generating a response.
  ///
  /// **Parameters:**
  /// - `chats` (List<Content>): A list of chat messages in the conversation. Each
  ///   message is represented as a `Content` object.
  /// - `modelName` (String?, optional): The name of the AI model to use for the
  ///   chat. Defaults to the system's preferred model if not provided.
  /// - `safetySettings` (List<SafetySetting>?, optional): Configures safety
  ///   settings for the response, such as filtering sensitive content.
  /// - `generationConfig` (GenerationConfig?, optional): Controls the response
  ///   generation behavior, like maximum length, temperature, etc.
  /// - `systemPrompt` (String?, optional): A custom system-level prompt to guide
  ///   the AI's behavior throughout the conversation.
  ///
  /// **Returns:**
  /// - `Future<Candidates?>`: A future that resolves to a `Candidates` object
  ///   containing the AI's response. Returns `null` if the process fails.
  ///
  /// **Example Usage:**
  /// ```dart
  /// final response = await Gemini.instance.chat([
  ///   Content(role: "user", parts: [Part.text("Tell me a joke.")]),
  /// ]);
  /// print(response?.content?.parts.first);
  /// ```
  @override
  Future<Candidates?> chat(List<Content> chats,
          {String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig,
          String? systemPrompt}) =>
      _impl.chat(chats,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName,
          systemPrompt: systemPrompt);

  /// Streams the ongoing chat interactions and responses in real-time. This method
  /// allows you to send a list of chat messages (contents) and receive responses as a stream,
  /// enabling real-time communication or processing of chat-like conversations.
  ///
  /// **Usage:**
  /// This method provides a continuous stream of responses for each chat input. You can use it
  /// to implement real-time conversational AI systems where the response is processed as it arrives.
  ///
  /// **Example:**
  /// ```dart
  /// Gemini.instance.streamChat([
  ///   Content(parts: [Part.text('Hello, how are you?')]),
  /// ]).listen((response) {
  ///   print(response.output); // Handle real-time responses here.
  /// });
  /// ```
  @override
  Stream<Candidates> streamChat(
    List<Content> chats, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) =>
      _impl.streamChat(chats,
          modelName: modelName,
          safetySettings: safetySettings,
          generationConfig: generationConfig);

  /// [countTokens] When using long prompts, it might be useful to count tokens
  /// before sending any content to the model.
  /// * not implemented yet
  @override
  Future<int?> countTokens(String text,
          {String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.countTokens(text,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName);

  /// [info]
  /// If you `GET` a model's URL, the API used the `get` method to return
  /// information about that model such as version, display name, input token limit, etc.
  @override
  Future<GeminiModel> info({required String model}) => _impl.info(model: model);

  /// [listModels]
  /// If you `GET` the `models` directory, it used the `list` method to list
  /// all of the models available through the API, including both the Gemini and PaLM family models.
  @override
  Future<List<GeminiModel>> listModels() => _impl.listModels();

  /// [streamGenerateContent] By default, the model returns a response after
  /// completing the entire generation process.
  /// You can achieve faster interactions by not waiting
  /// for the entire result, and instead use streaming to handle partial results.
  @Deprecated('Please use `prompt` or `promptStream` instead')
  @override
  Stream<Candidates> streamGenerateContent(String text,
          {List<Uint8List>? images,
          String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.streamGenerateContent(text,
          images: images,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName);

  /// [textAndImage] If the input contains both text and image, use
  /// the `gemini-1.5-flash` model. The following snippets help you build a request and send it to the REST API.
  @Deprecated('Please use `prompt` or `promptStream` instead')
  @override
  Future<Candidates?> textAndImage(
          {required String text,
          required List<Uint8List> images,
          String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.textAndImage(
          text: text,
          images: images,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName);

  /// This method is deprecated. Please use `prompt` or `promptStream` instead.
  ///
  /// Processes the provided text input to generate AI responses based on the
  /// specified model and configuration settings.
  ///
  /// **Parameters:**
  /// - `text` (String): The input text to process. This is the main content
  ///   for which a response will be generated.
  /// - `modelName` (String?, optional): The name of the AI model to be used
  ///   for generating the response. If not provided, the default model is used.
  /// - `safetySettings` (List<SafetySetting>?, optional): A list of safety
  ///   settings to customize the response generation, such as filtering
  ///   inappropriate content.
  /// - `generationConfig` (GenerationConfig?, optional): Configuration
  ///   settings to control the response generation behavior, like maximum
  ///   length, temperature, and more.
  ///
  /// **Returns:**
  /// - `Future<Candidates?>`: A future that resolves to a `Candidates` object,
  ///   containing the generated AI responses. Returns `null` if the process fails.
  ///
  /// **Note:** This method is deprecated and will be removed in future versions.
  /// Use the `prompt` or `promptStream` methods for enhanced functionality and
  /// greater flexibility.
  @Deprecated('Please use `prompt` or `promptStream` instead')
  @override
  Future<Candidates?> text(String text,
          {String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.text(text,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName);

  /// [Embedding] is a technique used to represent information as a
  /// list of floating point numbers in an array.
  /// With Gemini, you can represent text (words, sentences, and blocks of text)
  /// in a vectorized form, making it easier to compare and contrast embeddings.
  /// For example, two texts that share a similar subject matter or sentiment
  /// should have similar embeddings, which can be identified through mathematical
  /// comparison techniques such as cosine similarity.
  ///
  /// Use the `embedding-001` model with either [embedContent] or [batchEmbedContents]
  @override
  Future<List<List<num>?>?> batchEmbedContents(List<String> texts,
          {String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.batchEmbedContents(texts,
          safetySettings: safetySettings,
          generationConfig: generationConfig,
          modelName: modelName);

  /// Embeds the provided text content into a vector representation, typically used for
  /// similarity search, semantic analysis, or other tasks that require a vectorized
  /// representation of the input text.
  ///
  /// **Usage:**
  /// This method takes a string of text and returns its vectorized embedding (a list of numbers),
  /// which can be used for various machine learning tasks such as search, clustering, or recommendation.
  ///
  /// **Example:**
  /// ```dart
  /// final embedding = await Gemini.instance.embedContent('This is a sample text');
  /// print(embedding); // A list of numbers representing the text's embedding.
  /// ```
  @override
  Future<List<num>?> embedContent(String text,
          {String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.embedContent(text,
          safetySettings: safetySettings,
          generationConfig: generationConfig,
          modelName: modelName);

  dynamic typeProvider;
  bool disableAutoUpdateModelName;

  @override
  Future<void> cancelRequest() => _impl.cancelRequest();

  /// Sends a request to the AI and receives a single response. This is the
  /// standard method for one-off prompts.
  ///
  /// **Parameters:**
  /// - `parts` (List<Part>, required): A list of `Part` objects representing the
  ///   input data (e.g., text, files, binary data).
  /// - `model` (String?, optional): The name of the AI model to use. Defaults
  ///   to the system's preferred model if not provided.
  /// - `safetySettings` (List<SafetySetting>?, optional): Configures safety
  ///   settings for the response generation.
  /// - `generationConfig` (GenerationConfig?, optional): Controls the response
  ///   generation behavior, like maximum length, temperature, etc.
  ///
  /// **Returns:**
  /// - `Future<Candidates?>`: A future that resolves to a `Candidates` object
  ///   containing the generated response.
  ///
  /// **Example Usage:**
  /// ```dart
  /// Gemini.instance.prompt(parts: [
  ///   Part.text('What are the benefits of renewable energy?'),
  /// ]).then((value) {
  ///   print(value?.content?.parts.first);
  /// });
  /// ```
  @override
  Future<Candidates?> prompt({
    required List<Part> parts,
    String? model,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) =>
      _impl.prompt(
        parts: parts,
        generationConfig: generationConfig,
        model: model,
        safetySettings: safetySettings,
      );

  /// Sends a request to the AI and listens to a real-time stream of responses.
  /// Ideal for scenarios requiring immediate feedback or partial results.
  ///
  /// **Parameters:**
  /// - `parts` (List<Part>, required): A list of `Part` objects representing the
  ///   input data (e.g., text, files, binary data).
  /// - `model` (String?, optional): The name of the AI model to use. Defaults
  ///   to the system's preferred model if not provided.
  /// - `safetySettings` (List<SafetySetting>?, optional): Configures safety
  ///   settings for the response generation.
  /// - `generationConfig` (GenerationConfig?, optional): Controls the response
  ///   generation behavior, like maximum length, temperature, etc.
  ///
  /// **Returns:**
  /// - `Stream<Candidates?>`: A stream that emits `Candidates` objects containing
  ///   the generated responses.
  ///
  /// **Example Usage:**
  /// ```dart
  /// Gemini.instance.promptStream(parts: [
  ///   Part.text('Describe the future of AI in 50 years.'),
  /// ]).listen((value) {
  ///   print(value?.content?.parts.first);
  /// });
  /// ```
  @override
  Stream<Candidates?> promptStream(
          {required List<Part> parts,
          String? model,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.promptStream(
        parts: parts,
        generationConfig: generationConfig,
        model: model,
        safetySettings: safetySettings,
      );
}
