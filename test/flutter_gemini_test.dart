import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'env.dart' as env;

void main() {
  Gemini.init(apiKey: env.geminiKey, enableDebugging: true);

  test('check gemini to generate simple text', () async {
    final gemini = Gemini.instance;

    gemini.textInput("Write a story about a magic backpack.")
        .then((value) => value?.content?.parts?.last.text)
        .catchError((e) => print(e));
  });
}
