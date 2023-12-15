import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_gemini/src/models/candidates/candidates.dart';

import '../config/constants.dart';
import '../models/embedding/embedding_input_type.dart';
import '../models/gemini_model/gemini_model.dart';
import '../models/gemini_response/gemini_response.dart';
import '../models/gemini_safety/gemini_safety.dart';
import '../models/generation_config/generation_config.dart';
import '../repository/gemini_interface.dart';
import 'gemini_service.dart';

class GeminiImpl implements GeminiInterface {
  final GeminiService api;

  final List<SafetySetting>? safetySettings;
  final GenerationConfig? generationConfig;

  GeminiImpl({
    required this.api,
    this.safetySettings,
    this.generationConfig,
  }) {
    api
      ..safetySettings = safetySettings
      ..generationConfig = generationConfig;
  }

  @override
  Future chat(List<String> chats,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) {
    // TODO: implement chat
    throw UnimplementedError();
  }

  @override
  Future countTokens(String text,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) {
    // TODO: implement countTokens
    throw UnimplementedError();
  }

  @override
  Future embedding(String text,
      {EmbeddingInputType type = EmbeddingInputType.batchEmbedContents,
      String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) {
    // TODO: implement embedding
    throw UnimplementedError();
  }

  @override
  Future<GeminiModel> info({required String model}) {
    // TODO: implement info
    throw UnimplementedError();
  }

  @override
  Future<List<GeminiModel>> listModels() {
    // TODO: implement listModels
    throw UnimplementedError();
  }

  @override
  Stream streamGenerateContent(String text,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) {
    // TODO: implement streamGenerateContent
    throw UnimplementedError();
  }

  @override
  Future textAndImageInput(String text, Uint8List image,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) {
    base64Encode(image);
    // TODO: implement textAndImageInput
    throw UnimplementedError();
  }

  @override
  Future<Candidates?> textInput(String text,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async {
    final response = await api.post(
      "${modelName ?? Constants.defaultModel}:${Constants.defaultGenerateType}",
      data: {
        'contents': [
          {
            "parts": [
              {"text": text}
            ]
          }
        ]
      },
      generationConfig: generationConfig,
      safetySettings: safetySettings,
    );

    return GeminiResponse.fromJson(response.data).candidates?.last;
  }
}
