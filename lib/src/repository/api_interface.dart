import 'package:dio/dio.dart';
import '../models/gemini_safety/gemini_safety.dart';
import '../models/generation_config/generation_config.dart';

/// [ApiInterface] is api helper service class
abstract class ApiInterface {
  GenerationConfig? generationConfig;
  List<SafetySetting>? safetySettings;

  Future<Response> post(
    String route, {
    required Map<String, Object>? data,
    GenerationConfig? generationConfig,
    List<SafetySetting>? safetySettings,
  });

  Future<Response> get(String route);
}
