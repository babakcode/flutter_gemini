import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_gemini/src/models/candidates/candidates.dart';
import '../config/constants.dart';
import '../repository/gemini_interface.dart';
import 'gemini_service.dart';

/// [GeminiImpl]
/// In this class we declare and implement all the functions body
class GeminiImpl implements GeminiInterface {
  final GeminiService api;

  final splitter = const LineSplitter();

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
    Gemini.instance.typeProvider?.clear();

    final response = await api.post(
      "${modelName ?? Constants.defaultModel}:${Constants.defaultGenerateType}",
      data: {'contents': chats.map((e) => e.toJson()).toList()},
      generationConfig: generationConfig,
      safetySettings: safetySettings,
    );

    Gemini.instance.typeProvider?.loading = false;
    return GeminiResponse.fromJson(response.data).candidates?.lastOrNull;
  }

  @override
  Future<int?> countTokens(String text,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async {
    Gemini.instance.typeProvider?.clear();
    final response = await api.post(
      "${modelName ?? Constants.defaultModel}:countTokens",
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
    Gemini.instance.typeProvider?.loading = false;
    return response.data?['totalTokens'];
  }

  @override
  Future<GeminiModel> info({required String model}) async {
    Gemini.instance.typeProvider?.clear();
    final response = await api.get('models/$model');

    Gemini.instance.typeProvider?.loading = false;
    return GeminiModel.fromJson(response.data);
  }

  @override
  Future<List<GeminiModel>> listModels() async {
    Gemini.instance.typeProvider?.clear();
    final response = await api.get('models');
    Gemini.instance.typeProvider?.loading = false;
    return GeminiModel.jsonToList(response.data['models']);
  }

  @override
  Stream<Candidates> streamChat(
    List<Content> chats, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) async* {
    Gemini.instance.typeProvider?.clear();
    final response = await api.post(
      '${modelName ?? Constants.defaultModel}:streamGenerateContent',
      isStreamResponse: true,
      data: {'contents': chats.map((e) => e.toJson()).toList()},
      generationConfig: generationConfig,
      safetySettings: safetySettings,
    );

    Gemini.instance.typeProvider?.loading = false;
    // return GeminiResponse.fromJson(response.data).candidates?.lastOrNull;
    if (response.statusCode == 200) {
      final ResponseBody rb = response.data;
      int index = 0;
      String modelStr = '';
      List<int> cacheUnits = [];
      List<int> list = [];

      await for (final itemList in rb.stream) {
        list = cacheUnits + itemList;

        cacheUnits.clear();

        String res = "";
        try {
          res = utf8.decode(list);
        } catch (e) {
          cacheUnits = list;
          continue;
        }

        res = res.trim();

        if (index == 0 && res.startsWith("[")) {
          res = res.replaceFirst('[', '');
        }
        if (res.startsWith(',')) {
          res = res.replaceFirst(',', '');
        }
        if (res.endsWith(']')) {
          res = res.substring(0, res.length - 1);
        }

        res = res.trim();

        for (final line in splitter.convert(res)) {
          if (modelStr == '' && line == ',') {
            continue;
          }
          modelStr += line;
          try {
            final candidate = Candidates.fromJson(
                (jsonDecode(modelStr)['candidates'] as List?)?.firstOrNull);
            yield candidate;
            Gemini.instance.typeProvider?.add(candidate.output);
            modelStr = '';
          } catch (e) {
            continue;
          }
        }
        index++;
      }
    }
  }

  @override
  Stream<Candidates> streamGenerateContent(String text,
      {List<Uint8List>? images,
      String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async* {
    Gemini.instance.typeProvider?.clear();

    final response = await api.post(
      '${modelName ?? ((images?.isNotEmpty ?? false) ? 'models/gemini-pro-vision' : Constants.defaultModel)}:streamGenerateContent',
      isStreamResponse: true,
      data: {
        'contents': [
          {
            "parts": [
              {"text": text},
              ...?images?.map((e) => {
                    "inline_data": {
                      "mime_type": "image/jpeg",
                      "data": base64Encode(e)
                    }
                  })
            ]
          }
        ]
      },
      generationConfig: generationConfig,
      safetySettings: safetySettings,
    );
    Gemini.instance.typeProvider?.loading = false;

    if (response.statusCode == 200) {
      final ResponseBody rb = response.data;
      int index = 0;
      String modelStr = '';
      List<int> cacheUnits = [];
      List<int> list = [];

      await for (final itemList in rb.stream) {
        list = cacheUnits + itemList;

        cacheUnits.clear();

        String res = "";
        try {
          res = utf8.decode(list);
        } catch (e) {
          print("error: $e");
          cacheUnits = list;
          continue;
        }

        res = res.trim();

        if (index == 0 && res.startsWith("[")) {
          res = res.replaceFirst('[', '');
        }
        if (res.startsWith(',')) {
          res = res.replaceFirst(',', '');
        }
        if (res.endsWith(']')) {
          res = res.substring(0, res.length - 1);
        }

        res = res.trim();

        for (final line in splitter.convert(res)) {
          if (modelStr == '' && line == ',') {
            continue;
          }
          modelStr += line;
          try {
            final candidate = Candidates.fromJson(
                (jsonDecode(modelStr)['candidates'] as List?)?.firstOrNull);
            yield candidate;
            Gemini.instance.typeProvider?.add(candidate.output);
            modelStr = '';
          } catch (e) {
            continue;
          }
        }
        index++;
      }
    }
  }

  @override
  Future<Candidates?> textAndImage(
      {required String text,
      required List<Uint8List> images,
      String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async {
    Gemini.instance.typeProvider?.clear();
    final response = await api.post(
      "${modelName ?? 'models/gemini-pro-vision'}:${Constants.defaultGenerateType}",
      data: {
        'contents': [
          {
            "parts": [
              {"text": text},
              ...images.map((e) => {
                    "inline_data": {
                      "mime_type": "image/jpeg",
                      "data": base64Encode(e)
                    }
                  })
            ]
          }
        ]
      },
      generationConfig: generationConfig,
      safetySettings: safetySettings,
    );
    Gemini.instance.typeProvider?.loading = false;
    return GeminiResponse.fromJson(response.data).candidates?.lastOrNull;
  }

  @override
  Future<Candidates?> text(String text,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async {
    Gemini.instance.typeProvider?.clear();
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

    final candidate =
        GeminiResponse.fromJson(response.data).candidates?.lastOrNull;
    Gemini.instance.typeProvider?.add(candidate?.output);
    return candidate;
  }

  @override
  Future<List<List<num>?>?> batchEmbedContents(List<String> texts,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async {
    Gemini.instance.typeProvider?.clear();
    final response = await api.post(
      "${modelName ?? 'models/embedding-001'}:batchEmbedContents",
      data: {
        'requests': texts
            .map((e) => {
                  "model": "models/embedding-001",
                  "content": {
                    "parts": [
                      {"text": e}
                    ]
                  }
                })
            .toList(),
      },
      generationConfig: generationConfig,
      safetySettings: safetySettings,
    );

    Gemini.instance.typeProvider?.loading = false;
    return (response.data['embeddings'] as List)
        .map((e) => (e['values'] as List).cast<num>())
        .toList();
  }

  @override
  Future<List<num>?> embedContent(String text,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async {
    Gemini.instance.typeProvider?.clear();
    final response = await api.post(
      "${modelName ?? 'models/embedding-001'}:embedContent",
      data: {
        "model": "models/embedding-001",
        "content": {
          "parts": [
            {"text": text}
          ]
        }
      },
      generationConfig: generationConfig,
      safetySettings: safetySettings,
    );
    Gemini.instance.typeProvider?.loading = false;
    return (response.data['embedding']['values'] as List).cast<num>();
  }
}
