import 'package:flutter/material.dart';

import '../../models/learn/block_content.dart';
import '../../utils/get_dialog_route.dart';
import 'in_text_button.dart';

class LiteratureCitation extends StatelessWidget {
  final LLitRefSegment segment;

  const LiteratureCitation({
    Key? key,
    required this.segment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: segment.references,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return const Text('(...)');
        }

        String citation =
            snapshot.data!.map((e) => e.harvardCitation).toList().join("; ");

        return InTextButton(
          text: '($citation)',
          onPressed: () => Navigator.of(context).push(
            getDialogRoute(
              context,
              'Detail citace',
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!
                    .map((e) => SelectableText(e.fullCitation))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
