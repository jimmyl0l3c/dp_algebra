import 'package:flutter/material.dart';

import '../../models/learn/block_segment.dart';
import 'in_text_button.dart';

class LiteratureReference extends StatelessWidget {
  final LLitRefSegment segment;

  const LiteratureReference({
    Key? key,
    required this.segment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InTextButton(
      text: segment.content,
    );
  }
}
