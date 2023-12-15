import 'dart:developer';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../flutter_gemini_test.dart';

void main() {
  Gemini.init(apiKey: apiKey, enableDebugging: true);

  test('check gemini to generate simple text', () async {
    /// an instance
    final gemini = Gemini.instance;
    await gemini
        .text("Write a story about a magic backpack.")
        .then((value) => log(value?.content?.parts?.last.text ?? ''))
        .catchError((e) => log('text input exception', error: e));
  });
}
