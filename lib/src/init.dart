import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_gemini/src/models/candidates/candidates.dart';
import 'config/constants.dart';
import 'implement/gemini_service.dart';
import 'models/embedding/embedding_input_type.dart';
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
class Gemini implements GeminiInterface {
  /// [enableDebugging]
  /// to see request progress
  static bool enableDebugging = false;

  /// private constructor [Gemini._]
  Gemini._({
    /// [apiKey] is required property
    required String apiKey,

    /// theses properties are optional
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) : _impl = GeminiImpl(
          api: GeminiService(
              Dio(BaseOptions(
                  baseUrl: Constants.baseUrl, contentType: 'application/json')),
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

  /// singleton initialize [Gemini.init]
  factory Gemini.init(
      {required String apiKey,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig,
      bool? enableDebugging}) {
    if (enableDebugging != null) {
      Gemini.enableDebugging = enableDebugging;
    }
    if (_firstInit) {
      _firstInit = false;
      instance = Gemini._(
          apiKey: apiKey,
          safetySettings: safetySettings,
          generationConfig: generationConfig);
    }
    return instance;
  }

  /// [chat] or `Multi-turn conversations`
  /// Using Gemini, you can build freeform conversations across multiple turns.
  /// * not implemented yet
  @override
  Future chat(List<String> chats,
          {String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.chat(chats,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName);

  /// [countTokens] When using long prompts, it might be useful to count tokens
  /// before sending any content to the model.
  /// * not implemented yet
  @override
  Future countTokens(String text,
          {String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.countTokens(text,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName);

  /// [embedding] is a technique used to represent information as a
  /// list of floating point numbers in an array.
  /// With Gemini, you can represent text (words, sentences, and blocks of text)
  /// in a vectorized form, making it easier to compare and contrast embeddings.
  /// For example, two texts that share a similar subject matter or sentiment
  /// should have similar embeddings, which can be identified through mathematical
  /// comparison techniques such as cosine similarity.
  ///
  /// Use the `embedding-001` model with either `embedContents` or `batchEmbedContents`:
  @override
  Future embedding(String text,
          {EmbeddingInputType type = EmbeddingInputType.batchEmbedContents,
          String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.embedding(text,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName,
          type: type);

  /// [info]
  /// If you `GET` a model's URL, the API uses the `get` method to return
  /// information about that model such as version, display name, input token limit, etc.
  @override
  Future<GeminiModel> info({required String model}) => _impl.info(model: model);

  /// [listModels]
  /// If you `GET` the `models` directory, it uses the `list` method to list
  /// all of the models available through the API, including both the Gemini and PaLM family models.
  @override
  Future<List<GeminiModel>> listModels() => _impl.listModels();

  /// [streamGenerateContent] By default, the model returns a response after
  /// completing the entire generation process.
  /// You can achieve faster interactions by not waiting
  /// for the entire result, and instead use streaming to handle partial results.
  @override
  Stream streamGenerateContent(String text,
          {String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.streamGenerateContent(text,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName);

  /// [textAndImage] If the input contains both text and image, use
  /// the `gemini-pro-vision` model. The following snippets help you build a request and send it to the REST API.
  @override
  Future<Candidates?> textAndImage(
          {required String text,
          required Uint8List image,
          String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.textAndImage(
          text: text,
          image: image,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName);

  /// [text] Use the `generateContent` method to generate a response
  /// from the model given an input message.
  /// If the input contains only text, use the `gemini-pro` model.
  @override
  Future<Candidates?> text(String text,
          {String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.text(text,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName);
}
