import 'package:flutter/material.dart';

/// TextEditingController subclass that replaces '-' with proper minus sign
class MathTextEditingController extends TextEditingController {
  MathTextEditingController({required text}) : super(text: text);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    return TextSpan(
      text: value.text.replaceAll('-', '\u2212'),
      style: style,
    );
  }
}
