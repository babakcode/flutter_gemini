import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_gemini/src/models/candidates/candidates.dart';

import 'config/constants.dart';
import 'implement/gemini_service.dart';
import 'models/embedding/embedding_input_type.dart';
import 'models/gemini_model/gemini_model.dart';
import 'models/gemini_response/gemini_response.dart';
import 'models/generation_config/generation_config.dart';
import 'repository/gemini_interface.dart';
import 'package:dio/dio.dart';

import 'implement/gemini_implement.dart';
import 'models/gemini_safety/gemini_safety.dart';

class Gemini implements GeminiInterface {

  /// to see request progress
  static bool enableDebugging = false;

  // private constructor
  Gemini._({
    required String apiKey,
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

  // singleton instance
  static late Gemini instance;
  static bool _firstInit = true;

  // initial properties
  GeminiImpl _impl;

  /// singleton initialize
  factory Gemini.init({
    required String apiKey,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
    bool? enableDebugging
  }) {
    if(enableDebugging != null){
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

  @override
  Future chat(List<String> chats,
          {String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.chat(chats,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName);

  @override
  Future countTokens(String text,
          {String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.countTokens(text,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName);

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

  @override
  Future<GeminiModel> info({required String model}) => _impl.info(model: model);

  @override
  Future<List<GeminiModel>> listModels() => _impl.listModels();

  @override
  Stream streamGenerateContent(String text,
          {String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.streamGenerateContent(text,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName);

  @override
  Future textAndImageInput(String text, Uint8List image,
          {String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.textAndImageInput(text, image,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName);

  @override
  Future<Candidates?> textInput(String text,
          {String? modelName,
          List<SafetySetting>? safetySettings,
          GenerationConfig? generationConfig}) =>
      _impl.textInput(text,
          generationConfig: generationConfig,
          safetySettings: safetySettings,
          modelName: modelName);
}
