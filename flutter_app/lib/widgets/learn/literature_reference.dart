import 'package:flutter/material.dart';

import '../../models/learn/block_segment.dart';
import 'in_text_button.dart';

class LiteratureReference extends StatelessWidget {
  final LBlockSegment segment;
  final ScrollController? scrollController;

  const LiteratureReference({
    super.key,
    required this.segment,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return InTextButton(
      text: segment.content,
      onPressed: scrollController == null
          ? null
          : () => scrollController!.animateTo(
                scrollController!.position.maxScrollExtent,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
              ),
    );
  }
}
