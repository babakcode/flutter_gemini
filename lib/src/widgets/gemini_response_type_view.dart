import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_gemini/src/provider/gemini_response_provider.dart';

class GeminiResponseTypeView extends StatelessWidget {
  final Widget Function(
          BuildContext context, Widget? child, String? response, bool loading)
      builder;

  final Widget? child;

  GeminiResponseTypeView({
    super.key,
    required this.builder,
    this.child,
  }) {
    Gemini.instance.typeProvider ??= GeminiResponseProvider();
  }

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.bottomCenter,
      child: ListenableBuilder(
          listenable: Gemini.instance.typeProvider!,
          child: child,
          builder: (context, child) {
            return builder(
              context,
              child,
              Gemini.instance.typeProvider!.lastTypeResponseOrNull,
              Gemini.instance.typeProvider!.loading,
            );
          }),
    );
  }
}
