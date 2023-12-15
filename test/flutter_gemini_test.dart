import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'env.dart' as secret_env;

void main() {
  Gemini.init(apiKey: secret_env.geminiKey);

  test('check gemini to generate simple text', () async {
    final gemini = Gemini.instance;
    print('request');
    await gemini
        .textInput("Write a story about a magic backpack.")
        .then((value) => print("value is ${value.toString()}"))
        .catchError((e) => print(e));
  });
}
