import 'dart:developer';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../flutter_gemini_test.dart';

void main() {
  Gemini.init(apiKey: apiKey, enableDebugging: true);

  test('Check Gemini\'s generated simple text and image response', () async {
    /// an instance
    final gemini = Gemini.instance;
    final file = File('assets/img.png');
    await gemini
        .textAndImage(
          text: "What is this picture?",
          images: [
            file.readAsBytesSync(),
          ],
        )
        .then((value) => log(value?.output ?? ''))
        .catchError((e) => log('textAndImageInput exception', error: e));
  });
}
