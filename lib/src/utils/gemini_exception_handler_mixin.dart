import 'package:dio/dio.dart';
import 'package:flutter_gemini/src/repository/api_interface.dart';
import 'package:flutter_gemini/src/utils/gemini_exception.dart';

/// A mixin that provides centralized exception handling for API requests.
/// This is designed to simplify error management by wrapping requests
/// with a handler that detects and processes exceptions.
///
/// **Usage:**
/// Add this mixin to a class implementing `ApiInterface` to gain access
/// to the `handler` method for streamlined API call management.
///
/// **Example:**
/// ```dart
/// class ApiService with GeminiExceptionHandler implements ApiInterface {
///   Future<Response> fetchData() async {
///     return await handler(() async {
///       return await dio.get('/endpoint');
///     });
///   }
/// }
/// ```
mixin GeminiExceptionHandler on ApiInterface {
  /// Wraps an API request and handles potential exceptions.
  ///
  /// **Parameters:**
  /// - `request` (Future<Response> Function()): A function that executes
  ///   the actual API request and returns a `Future<Response>`.
  ///
  /// **Returns:**
  /// - `Future<Response>`: The API response if the request succeeds.
  ///
  /// **Throws:**
  /// - `GeminiException`: If the response indicates an error or if a
  ///   DioException occurs.
  Future<Response> handler(Future<Response> Function() request) async {
    try {
      // Execute the API request.
      final res = await request();

      // Extract the HTTP status code.
      int statusCode = res.statusCode ?? 200;

      // If the status code indicates success, return the response.
      if (statusCode >= 200 && statusCode < 300) {
        return res;
      }

      // Throw a GeminiException if the status code indicates failure.
      throw GeminiException(res.data?['error'], statusCode: statusCode);
    } catch (e) {
      // Handle Dio-specific exceptions.
      if (e is DioException) {
        final data = e.response?.data;

        // Check if the response contains a raw `ResponseBody`.
        if (data is ResponseBody) {
          throw GeminiException(
            e.message ?? 'Something went wrong!',
            statusCode: e.response!.statusCode,
          );
        }

        // For other DioExceptions, throw a GeminiException with status -1.
        throw GeminiException(e.message ?? 'Something went wrong!',
            statusCode: -1);
      }

      // For all other exceptions, wrap them in a GeminiException.
      throw GeminiException(e, statusCode: -1);
    }
  }
}
