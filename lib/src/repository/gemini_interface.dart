import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_gemini/src/models/candidates/candidates.dart';
import '../../flutter_gemini.dart';

abstract class GeminiInterface {
  /// [listModels]
  /// If you `GET` the `models` directory, it used the `list` method to list
  /// all of the models available through the API, including both the Gemini and PaLM family models.
  Future<List<GeminiModel>> listModels();

  /// [info]
  /// If you `GET` a model's URL, the API used the `get` method to return
  /// information about that model such as version, display name, input token limit, etc.
  Future<GeminiModel> info({required String model});

  /// [text] Use the `generateContent` method to generate a response
  /// from the model given an input message.
  /// If the input contains only text, use the `gemini-pro` model.
  Future<Candidates?> text(
    String text, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });

  /// [Embedding] is a technique used to represent information as a
  /// list of floating point numbers in an array.
  /// With Gemini, you can represent text (words, sentences, and blocks of text)
  /// in a vectorized form, making it easier to compare and contrast embeddings.
  /// For example, two texts that share a similar subject matter or sentiment
  /// should have similar embeddings, which can be identified through mathematical
  /// comparison techniques such as cosine similarity.
  ///
  /// Use the `embedding-001` model with either [embedContent] or [batchEmbedContents]
  Future<List<List<num>?>?> batchEmbedContents(
    List<String> texts, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });

  /// [embedContent] description in upper comments
  Future<List<num>?> embedContent(
    String text, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });

  /// [countTokens] When using long prompts, it might be useful to count tokens
  /// before sending any content to the model.
  Future<int?> countTokens(
    String text, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });

  /// [streamGenerateContent] By default, the model returns a response after
  /// completing the entire generation process.
  /// You can achieve faster interactions by not waiting
  /// for the entire result, and instead use streaming to handle partial results.
  Stream<Candidates> streamGenerateContent(
    String text, {
    List<Uint8List>? images,
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });

  /// [chat] or `Multi-turn conversations`
  /// Using Gemini, you can build freeform conversations across multiple turns.
  Future<Candidates?> chat(
    List<Content> chats, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });

  /// [textAndImage] If the input contains both text and image, use
  /// the `gemini-pro-vision` model. The following snippets help you build a request and send it to the REST API.
  Future<Candidates?> textAndImage({
    required String text,
    required List<Uint8List> images,
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });

  // cancel request
  Future<void> cancelRequest();
}
