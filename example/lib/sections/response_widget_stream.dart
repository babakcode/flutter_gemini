import 'package:example/widgets/chat_input_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lottie/lottie.dart';

class ResponseWidgetSection extends StatefulWidget {
  const ResponseWidgetSection({super.key});

  @override
  State<ResponseWidgetSection> createState() => _SectionTextInputStreamState();
}

class _SectionTextInputStreamState extends State<ResponseWidgetSection> {
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  String? searchedText, result, _finishReason;
  bool _loading = false;

  String? get finishReason => _finishReason;
  bool get loading => _loading;

  set finishReason(String? set) {
    if (set != _finishReason) {
      setState(() => _finishReason = set);
    }
  }

  set loading(bool set) {
    if (set != loading) {
      setState(() => _loading = set);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (searchedText != null)
          MaterialButton(
              color: Colors.blue.shade700,
              onPressed: () {
                setState(() {
                  searchedText = null;
                  result = null;
                });
              },
              child: Text('search: $searchedText')),
        Expanded(
            child: loading
                ? Lottie.asset('assets/lottie/ai.json')
                : result != null
                    ? GeminiResponseTypeView(
                        builder: (context, child, response, loading) =>
                            Markdown(data: response ?? ''))
                    : const Center(child: Text('Search something!'))),
        if (finishReason != null) Text(finishReason!),
        ChatInputBox(
          controller: controller,
          onSend: () {
            if (controller.text.isNotEmpty) {
              searchedText = controller.text;
              controller.clear();
              loading = true;
              result = null;
              finishReason = null;

              gemini
                  .streamGenerateContent(searchedText!,
                      generationConfig: GenerationConfig(
                        maxOutputTokens: 2000,
                        temperature: 0.9,
                        topP: 0.1,
                        topK: 16,
                      ))
                  .listen((value) {
                result = (result ?? '') + (value.output ?? '');

                if (value.finishReason != 'STOP') {
                  finishReason = 'Finish reason is `RECITATION`';
                }
                loading = false;
              });
            }
          },
        ),
      ],
    );
  }
}
