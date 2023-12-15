import 'dart:developer';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../flutter_gemini_test.dart';

void main() {
  Gemini.init(
      apiKey: apiKey, enableDebugging: true);

  test('Check Gemini\'s generated simple chat responding', () async {
    /// an instance
    final gemini = Gemini.instance;

    await gemini
        .chat([
      Content(parts: [
        Parts(
            text: 'Write the first line of a story about a magic backpack.')
      ], role: 'user'),
      Content(parts: [
        Parts(
            text:
            'In the bustling city of Meadow brook, lived a young girl named Sophie. She was a bright and curious soul with an imaginative mind.')
      ], role: 'model'),
      Content(parts: [
        Parts(text: 'Can you set it in a quiet village in 1600s France?')
      ], role: 'user'),
    ])
        .then((value) => log(value?.output ?? 'without output'))
        .catchError((e) => log('chat', error: e));
  });
}
