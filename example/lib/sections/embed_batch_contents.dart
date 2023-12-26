import 'package:example/widgets/chat_input_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:lottie/lottie.dart';

class SectionBatchEmbedContents extends StatefulWidget {
  const SectionBatchEmbedContents({super.key});

  @override
  State<SectionBatchEmbedContents> createState() => _SectionTextInputStreamState();
}

class _SectionTextInputStreamState extends State<SectionBatchEmbedContents> {
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  String? searchedText; List<List<num>?>? result;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool set) => setState(() => _loading = set);

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
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(child: Text(result?.toString() ?? '')),
            )
                : const Center(child: Text('Search something!'))),

        ChatInputBox(
          controller: controller,
          onSend: () {
            if (controller.text.isNotEmpty) {
              searchedText = controller.text;
              controller.clear();
              loading = true;

              gemini.batchEmbedContents([searchedText!]).then((value) {
                result = value;
                loading = false;
              });
            }
          },
        )
      ],
    );
  }
}

