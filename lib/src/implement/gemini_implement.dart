import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_gemini/src/models/candidates/candidates.dart';
import 'package:flutter_gemini/src/models/content/content.dart';
import 'package:flutter_gemini/src/models/parts/parts.dart';

import '../config/constants.dart';
import '../models/gemini_model/gemini_model.dart';
import '../models/gemini_response/gemini_response.dart';
import '../models/gemini_safety/gemini_safety.dart';
import '../models/generation_config/generation_config.dart';
import '../repository/gemini_interface.dart';
import 'gemini_service.dart';

/// [GeminiImpl]
/// In this class we declare and implement all the functions body
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
  Future<Candidates?> chat(List<Content> chats,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async {
    final response = await api.post(
      "${modelName ?? Constants.defaultModel}:${Constants.defaultGenerateType}",
      data: {
        'contents': chats.map((e) => e.toJson()).toList()
      },
      generationConfig: generationConfig,
      safetySettings: safetySettings,
    );

    return GeminiResponse.fromJson(response.data).candidates?.lastOrNull;
  }

  @override
  Future<int?> countTokens(String text,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async {
    try{
      final response = await api.post(
        "${modelName ?? Constants.defaultModel}:countTokens",
        data: {
          'contents': [
            {
              "parts": [
                {"text": text},
              ]
            }
          ]
        },
        generationConfig: generationConfig,
        safetySettings: safetySettings,
      );
      return response.data?['totalTokens'];
    }catch(e) {
      rethrow;
    }
  }


  @override
  Future<GeminiModel> info({required String model}) async {
    try{
      final response = await api.get('models/$model');
      return GeminiModel.fromJson(response.data);
    }catch(e) {
      rethrow;
    }
  }

  @override
  Future<List<GeminiModel>> listModels() async {
    try{
      final response = await api.get('models');
      return GeminiModel.jsonToList(response.data['models']);
    }catch(e) {
      rethrow;
    }
  }

  @override
  Future<Stream> streamGenerateContent(String text,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig})async {
    throw UnimplementedError('Unimplemented method. This feature will be added in the newer versions');
  //   final response = await api.postStream(
  //   "${modelName ?? Constants.defaultModel}:streamGenerateContent",
  //   data: {
  //     'contents': [
  //       {
  //         "parts": [
  //           {"text": text},
  //         ]
  //       }
  //     ]
  //   },
  //   generationConfig: generationConfig,
  //   safetySettings: safetySettings,
  // );
  // return response;
  }

  @override
  Future<Candidates?> textAndImage(
      {required String text,
      required Uint8List image,
      String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async {
    final response = await api.post(
      "${modelName ?? 'models/gemini-pro-vision'}:${Constants.defaultGenerateType}",
      data: {
        'contents': [
          {
            "parts": [
              {"text": text},
              {
                "inline_data": {
                  "mime_type": "image/jpeg",
                  "data": base64Encode(image)
                }
              }
            ]
          }
        ]
      },
      generationConfig: generationConfig,
      safetySettings: safetySettings,
    );
    return GeminiResponse.fromJson(response.data).candidates?.lastOrNull;
  }

  @override
  Future<Candidates?> text(String text,
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

    return GeminiResponse.fromJson(response.data).candidates?.lastOrNull;
  }

  @override
  Future batchEmbedContents(List<String> texts, {String? modelName, List<SafetySetting>? safetySettings, GenerationConfig? generationConfig}) async {
    throw UnimplementedError('Unimplemented method. This feature will be added in the newer versions');
    // final response = await api.post(
    //   "${modelName ?? 'models/embedding-001'}:batchEmbedContents",
    //   data: {
    //     'requests': texts.map((e) => {
    //       'model': 'models/embedding-001',
    //       'content': [
    //         {
    //           'parts': [
    //             {'text': e},
    //           ]
    //         }
    //       ]
    //     }).toList(),
    //   },
    //   generationConfig: generationConfig,
    //   safetySettings: safetySettings,
    // );
    // return GeminiResponse.fromJson(response.data).candidates?.lastOrNull;
  }

  @override
  Future embedContents(String text, {String? modelName, List<SafetySetting>? safetySettings, GenerationConfig? generationConfig}) async {
    throw UnimplementedError('Unimplemented method. This feature will be added in the newer versions');
    // final response = await api.post(
    //   "${modelName ?? 'models/embedding-001'}:embedContent",
    //   data: {
    //     'model': 'models/embedding-001',
    //     'contents': [
    //       {
    //         'parts': [
    //           {'text': text},
    //         ]
    //       }
    //     ]
    //   },
    //   generationConfig: generationConfig,
    //   safetySettings: safetySettings,
    // );
    // return GeminiResponse.fromJson(response.data).candidates?.lastOrNull;
  }
}
