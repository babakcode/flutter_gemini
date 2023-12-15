import 'dart:developer';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(
      apiKey: '--- Your Gemini Api Key ---', enableDebugging: true);

  test('check gemini to generate simple text', () async {
    /// an instance
    final gemini = Gemini.instance;

    /// text
    await gemini
        .text("Write a story about a magic backpack.")
        .then((value) => log(value?.content?.parts?.last.text ?? ''))
        .catchError((e) => log('text input exception', error: e));

    /// text and image
    final file = File('assets/img.png');
    await gemini
        .textAndImage(
          text: "What is this picture?",
          image: file.readAsBytesSync(),
        )
        .then((value) => log(value?.content?.parts?.last.text ?? ''))
        .catchError((e) => log('textAndImageInput exception', error: e));
  });
}
