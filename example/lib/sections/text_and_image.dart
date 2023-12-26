import 'dart:typed_data';

import 'package:example/widgets/chat_input_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class SectionTextAndImageInput extends StatefulWidget {
  const SectionTextAndImageInput({super.key});

  @override
  State<SectionTextAndImageInput> createState() =>
      _SectionTextAndImageInputState();
}

class _SectionTextAndImageInputState extends State<SectionTextAndImageInput> {
  final ImagePicker picker = ImagePicker();
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  String? searchedText, result;
  bool _loading = false;

  Uint8List? selectedImage;

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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: loading
                      ? Lottie.asset('assets/lottie/ai.json')
                      : result != null
                          ? Markdown(
                              data: result!,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                            )
                          : const Center(
                              child: Text('Search something!'),
                            ),
                ),
                if (selectedImage != null)
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.memory(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
        ChatInputBox(
          controller: controller,
          onClickCamera: () async {
            // Capture a photo.
            final XFile? photo =
                await picker.pickImage(source: ImageSource.camera);

            if (photo != null) {
              photo.readAsBytes().then((value) => setState(() {
                    selectedImage = value;
                  }));
            }
          },
          onSend: () {
            if (controller.text.isNotEmpty && selectedImage != null) {
              searchedText = controller.text;
              controller.clear();
              loading = true;

              gemini.textAndImage(
                  text: searchedText!, images: [selectedImage!]).then((value) {
                result = value?.content?.parts?.last.text;
                loading = false;
              });
            }
          },
        ),
      ],
    );
  }
}
