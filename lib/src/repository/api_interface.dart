import 'package:dio/dio.dart';
import '../models/gemini_safety/gemini_safety.dart';
import '../models/generation_config/generation_config.dart';

/// [ApiInterface] is an API helper service class.
///
/// This class defines the contract for making API requests. It includes methods
/// for `POST` and `GET` requests, and allows the passing of configuration settings
/// such as `generationConfig` and `safetySettings` for controlling API behavior.

abstract class ApiInterface {
  /// Optional configuration for generation parameters.
  GenerationConfig? generationConfig;

  /// Optional list of safety settings to apply during the API request.
  List<SafetySetting>? safetySettings;

  /// Sends a `POST` request to the specified route with the given data.
  ///
  /// Parameters:
  /// - `route`: The API endpoint to which the request will be sent.
  /// - `data`: A map of data to send with the request. The keys are strings and the values are objects.
  /// - `generationConfig`: An optional configuration for controlling the generation behavior.
  /// - `safetySettings`: An optional list of safety settings to apply during the request.
  ///
  /// Returns:
  /// A `Response` object representing the outcome of the HTTP request.
  Future<Response> post(
    String route, {
    required Map<String, Object>? data,
    GenerationConfig? generationConfig,
    List<SafetySetting>? safetySettings,
  });

  /// Sends a `GET` request to the specified route.
  ///
  /// Parameters:
  /// - `route`: The API endpoint to which the request will be sent.
  ///
  /// Returns:
  /// A `Response` object representing the outcome of the HTTP request.
  Future<Response> get(String route);
}
