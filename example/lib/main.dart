import 'package:flutter_gemini/flutter_gemini.dart';

const apiKey = 'AIza------tMww4--------------';
void main() {

  Gemini.init(apiKey: apiKey, enableDebugging: true);

  Gemini.instance.prompt(parts: [
    Part.text('Write a story about a magic backpack'),
  ]).then((value) {
    print(value?.output);
  });
}