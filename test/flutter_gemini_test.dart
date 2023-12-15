import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(apiKey: '--- Your Gemini Api Key ---', enableDebugging: true);

  test('check gemini to generate simple text', () async {
    final gemini = Gemini.instance;

    gemini
        .textInput("Write a story about a magic backpack.")
        .then((value) => log(value?.content?.parts?.last.text ?? ''))
        .catchError((e) => log('text input exception', error: e));
  });
}
