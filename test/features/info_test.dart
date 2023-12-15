import 'dart:developer';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../flutter_gemini_test.dart';

void main() {
  Gemini.init(
      apiKey: apiKey, enableDebugging: true);

  test('Check Gemini\'s generated model info', () async {
    /// an instance
    final gemini = Gemini.instance;
    await gemini
        .info(model: 'gemini-pro')
        .then((info) => print(info))
        .catchError((e) => log('text input exception', error: e));
  });
}
