import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_gemini/src/repository/api_interface.dart';
import 'package:flutter_gemini/src/utils/gemini_exception_handler_mixin.dart';
import '../init.dart';
import '../models/gemini_safety/gemini_safety.dart';
import '../models/generation_config/generation_config.dart';

/// [GeminiService] is an API helper service class that extends [ApiInterface] and mixes in [GeminiExceptionHandler].
/// This service is used for making HTTP requests (POST, GET) to interact with the Gemini API.
class GeminiService extends ApiInterface with GeminiExceptionHandler {
  final Dio dio; // Dio instance for making HTTP requests.
  final String apiKey; // The API key for authenticating requests.
  CancelToken? cancelToken; // Token used to cancel HTTP requests.

  /// Constructor for [GeminiService]. Optionally enables logging for debugging.
  GeminiService(this.dio, {required this.apiKey}) {
    if ((Gemini.enableDebugging ?? false)) {
      dio.interceptors.add(LogInterceptor(
          requestBody: true,
          responseBody: true)); // Adds logging if debugging is enabled.
    }
  }

  /// Sends a POST request to the Gemini API.
  ///
  /// [route] is the endpoint route.
  /// [data] contains the body of the request.
  /// [generationConfig] configures generation parameters for the request.
  /// [safetySettings] configures safety settings for the request.
  /// [isStreamResponse] determines whether the response should be streamed.
  @override
  Future<Response> post(
    String route, {
    required Map<String, Object>? data,
    GenerationConfig? generationConfig,
    List<SafetySetting>? safetySettings,
    bool isStreamResponse = false,
  }) async {
    cancelToken ??= CancelToken(); // Ensure cancelToken is initialized.

    // If safetySettings are provided, include them in the request data.
    if (safetySettings != null || this.safetySettings != null) {
      final listSafetySettings = safetySettings ?? this.safetySettings ?? [];
      final items = [];
      for (final safetySetting in listSafetySettings) {
        items.add({
          'category': safetySetting.category.value,
          'threshold': safetySetting.threshold.value,
        });
      }
      data?['safetySettings'] = items; // Add safety settings to data.
    }

    // If generationConfig is provided, include it in the request data.
    if (generationConfig != null || this.generationConfig != null) {
      data?['generationConfig'] =
          generationConfig?.toJson() ?? this.generationConfig?.toJson() ?? {};
    }

    // Make the POST request using Dio.
    return handler(() => dio.post(
          route,
          data: jsonEncode(data), // Encode the data as JSON.
          queryParameters: {
            'key': apiKey
          }, // Include the API key in the query parameters.
          options: Options(
              responseType: isStreamResponse == true
                  ? ResponseType.stream
                  : null), // Set response type if streaming is enabled.
          cancelToken: cancelToken, // Attach the cancel token.
        ));
  }

  /// Sends a GET request to the Gemini API.
  ///
  /// [route] is the endpoint route.
  @override
  Future<Response> get(String route) async {
    cancelToken ??= CancelToken(); // Ensure cancelToken is initialized.

    // Make the GET request using Dio.
    return handler(() => dio.get(route,
        queryParameters: {
          'key': apiKey
        }, // Include the API key in the query parameters.
        cancelToken: cancelToken)); // Attach the cancel token.
  }

  /// Cancels an ongoing request if it exists.
  Future<void> cancelRequest() async {
    if (cancelToken != null) {
      cancelToken!.cancel(); // Cancel the request.
      cancelToken = null; // Nullify the cancel token.
    }
  }
}
