import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_gemini/src/repository/api_interface.dart';
import 'package:flutter_gemini/src/utils/gemini_exception.dart';

mixin GeminiExceptionHandler on ApiInterface {
  Future<Response> handler(Future<Response> Function() request) async {
    try {
      final res = await request();

      int statusCode = res.statusCode ?? 200;
      if (statusCode >= 200 && statusCode < 300) {
        return res;
      }

      throw GeminiException(res.data?['error'], statusCode: statusCode);
    } catch (e) {
      if (e is DioException) {
        final data = e.response?.data;

        if (data is ResponseBody) {
          throw GeminiException(
            e.message ?? 'Something went wrong!',
            statusCode: e.response!.statusCode,
          );
        }

        throw GeminiException(e.message ?? 'Something went wrong!',
            statusCode: -1);
      } else if (e is SocketException) {
        throw GeminiException(e.message, statusCode: -1);
      }

      throw GeminiException(e, statusCode: -1);
    }
  }
}
