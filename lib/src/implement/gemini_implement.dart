import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:mime/mime.dart';
import '../config/constants.dart';
import '../repository/gemini_interface.dart';
import 'gemini_service.dart';

/// [GeminiImpl]
/// In this class we declare and implement all the functions body
class GeminiImpl implements GeminiInterface {
  final GeminiService _api;

  final _splitter = const LineSplitter();

  final List<SafetySetting>? safetySettings;
  final GenerationConfig? generationConfig;
  List<GeminiModel>? _models;

  GeminiImpl({
    required GeminiService api,
    this.safetySettings,
    this.generationConfig,
  }) : _api = api {
    _api
      ..safetySettings = safetySettings
      ..generationConfig = generationConfig;
  }

  /// Processes a batch of texts and returns embeddings for each text.
  /// Embeddings are vectors representing the semantic meaning of each input text.
  ///
  /// Parameters:
  /// - `texts`: A list of strings that you want to embed.
  /// - `modelName`: The name of the model to use (optional). Defaults to the model expected for embedding tasks.
  /// - `safetySettings`: A list of safety settings to apply to the request (optional).
  /// - `generationConfig`: Configuration parameters for generation (optional).
  ///
  /// Returns:
  /// A list of embeddings for each input text as lists of numerical values.
  @override
  Future<List<List<num>?>?> batchEmbedContents(
    List<String> texts, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) async {
    modelName = await _checkModel(
      userModel: modelName,
      expectedModel: 'models/embedding-001',
    );

    Gemini.instance.typeProvider?.clear();
    final response = await _api.post(
      "$modelName:batchEmbedContents",
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

  /// Generates a chat-like response based on the provided input messages.
  /// The conversation history is sent as a list of `Content` objects.
  ///
  /// Parameters:
  /// - `chats`: A list of `Content` objects that represent the chat messages exchanged.
  /// - `modelName`: The model name for generating the response (optional).
  /// - `safetySettings`: Safety settings to apply (optional).
  /// - `generationConfig`: Configuration for the generation process (optional).
  /// - `systemPrompt`: An optional system instruction that guides the behavior of the model.
  ///
  /// Returns:
  /// The last candidate response generated from the chat input, wrapped in the `Candidates` class.
  @override
  Future<Candidates?> chat(List<Content> chats,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig,
      String? systemPrompt}) async {
    // get current model name related to this method
    modelName = await _checkModel(
      userModel: modelName,
      expectedModel: Constants.defaultModel,
    );

    Gemini.instance.typeProvider?.clear();

    final response = await _api.post(
      "$modelName:${Constants.defaultGenerateType}",
      data: {
        'contents': chats.map((e) => e.toJson()).toList(),
        if (systemPrompt != null)
          'system_instruction': {
            "parts": [
              {"text": systemPrompt}
            ]
          },
      },
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
    // get current model name related to this method
    modelName = await _checkModel(
      userModel: modelName,
      expectedModel: Constants.defaultModel,
    );

    Gemini.instance.typeProvider?.clear();
    final response = await _api.post(
      "$modelName:countTokens",
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
  Future<List<num>?> embedContent(String text,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async {
    // get current model name related to this method
    modelName = await _checkModel(
      userModel: modelName,
      expectedModel: 'models/embedding-001',
    );

    Gemini.instance.typeProvider?.clear();
    final response = await _api.post(
      "$modelName:embedContent",
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

  @override
  Future<GeminiModel> info({required String model}) async {
    Gemini.instance.typeProvider?.clear();
    final response = await _api.get('models/$model');

    Gemini.instance.typeProvider?.loading = false;
    return GeminiModel.fromJson(response.data);
  }

  @override
  Future<List<GeminiModel>> listModels() async {
    Gemini.instance.typeProvider?.clear();
    final response = await _api.get('models');
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
    // get current model name related to this method
    modelName = await _checkModel(
      userModel: modelName,
      expectedModel: Constants.defaultModel,
    );

    Gemini.instance.typeProvider?.clear();
    final response = await _api.post(
      '$modelName:streamGenerateContent',
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

        for (final line in _splitter.convert(res)) {
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
    // get current model name related to this method
    modelName = await _checkModel(
      userModel: modelName,
      expectedModel: Constants.defaultModel,
    );

    Gemini.instance.typeProvider?.clear();

    final response = await _api.post(
      '$modelName:streamGenerateContent',
      isStreamResponse: true,
      data: {
        'contents': [
          {
            "parts": [
              {"text": text},
              ...?images?.map((e) => {
                    "inline_data": {
                      "mime_type":
                          lookupMimeType('', headerBytes: e) ?? "image/jpg",
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
          log('error in parsing chunk', error: e, name: 'Gemini_Exception');
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

        for (final line in _splitter.convert(res)) {
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
  Future<Candidates?> text(String text,
      {String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async {
    // get current model name related to this method
    modelName = await _checkModel(
      userModel: modelName,
      expectedModel: Constants.defaultModel,
    );

    Gemini.instance.typeProvider?.clear();

    final response = await _api.post(
      "$modelName:${Constants.defaultGenerateType}",
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

    final candidate =
        GeminiResponse.fromJson(response.data).candidates?.lastOrNull;
    Gemini.instance.typeProvider?.add(candidate?.output);
    return candidate;
  }

  @override
  Future<Candidates?> textAndImage(
      {required String text,
      required List<Uint8List> images,
      String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async {
    // get current model name related to this method
    modelName = await _checkModel(
      userModel: modelName,
      expectedModel: Constants.defaultModel,
    );

    Gemini.instance.typeProvider?.clear();
    final response = await _api.post(
      "$modelName:${Constants.defaultGenerateType}",
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
  Future<void> cancelRequest() => _api.cancelRequest();

  Future<String> _checkModel({
    required String? userModel,
    required String expectedModel,
  }) async {
    if (Gemini.instance.disableAutoUpdateModelName) {
      return userModel ?? expectedModel;
    }

    _models ??= await listModels();

    if (userModel != null &&
        !_models!.any((element) => element.name == userModel)) {
      log('This model is deprecated, Please use the correct one!',
          name: 'GEMINI_WARNING');
    }

    if (_models!.any((element) => element.name == expectedModel)) {
      return expectedModel;
    }

    log(
      'UPDATE_REQUIRED | Please notify the developer to address this issue. '
      'Alternatively, you can create a fork, resolve the issue, '
      'and submit a pull request to contribute the fix.',
      name: 'GEMINI_WARNING',
    );

    int index = _models!.indexWhere(
        (element) => element.name?.toLowerCase().contains('latest') ?? false);
    if (index != -1) {
      return _models![index].name!;
    }
    index = _models!.indexWhere(
        (element) => element.name?.toLowerCase().contains('flash') ?? false);
    if (index != -1) {
      return _models![index].name!;
    }
    if ((userModel?.toLowerCase().contains('pro') ?? false) ||
        expectedModel.toLowerCase().contains('pro')) {
      index = _models!
          .indexWhere((element) => element.name?.contains('pro') ?? false);
      if (index != -1) {
        return _models![index].name!;
      }
    }

    return Constants.defaultModel;
  }

  @override
  Future<Candidates?> prompt({
    required List<Part> parts,
    String? model,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) async {
    // get current model name related to this method
    model = await _checkModel(
      userModel: model,
      expectedModel: Constants.defaultModel,
    );

    Gemini.instance.typeProvider?.clear();
    final response = await _api.post(
      "$model:${Constants.defaultGenerateType}",
      data: {
        'contents': [
          {'parts': parts.map((e) => Part.toJson(e)).toList()}
        ]
      },
      generationConfig: generationConfig,
      safetySettings: safetySettings,
    );
    Gemini.instance.typeProvider?.loading = false;
    return GeminiResponse.fromJson(response.data).candidates?.lastOrNull;
  }

  @override
  Stream<Candidates?> promptStream(
      {required List<Part> parts,
      String? model,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async* {
    // get current model name related to this method
    model = await _checkModel(
      userModel: model,
      expectedModel: Constants.defaultModel,
    );

    final response = await _api.post(
      '$model:streamGenerateContent',
      data: {
        'contents': [
          {'parts': parts.map((e) => Part.toJson(e)).toList()}
        ]
      },
      generationConfig: generationConfig,
      safetySettings: safetySettings,
      isStreamResponse: true,
    );

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
          print(res);
          print('------------------------');
        } catch (e) {
          log('error in parsing chunk', error: e, name: 'Gemini_Exception');
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

        for (final line in _splitter.convert(res)) {
          if (modelStr == '' && line == ',') {
            continue;
          }
          modelStr += line;
          try {
            final candidate = Candidates.fromJson(
                (jsonDecode(modelStr)['candidates'] as List?)?.firstOrNull);
            log('---------------------------------', name: 'Chunk');
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
}
