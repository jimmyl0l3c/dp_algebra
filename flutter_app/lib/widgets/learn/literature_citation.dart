import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../models/learn/block_content.dart';
import '../loading.dart';

class LiteratureCitation extends StatelessWidget {
  final LBlockLiteratureContent segment;

  const LiteratureCitation({
    Key? key,
    required this.segment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: FutureBuilder(
        future: segment.literature,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _getLitColumn(context, [const Loading()]);
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return _getLitColumn(context, [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0, left: 24.0),
                child: Text('No literature found'),
              )
            ]);
          }

          return _getLitColumn(
            context,
            snapshot.data!
                .mapIndexed((i, e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 24),
                            child: Text('[${i + 1}]'),
                          ),
                          const SizedBox(width: 16),
                          SelectableText(e.fullCitation),
                        ],
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _getLitColumn(BuildContext context, List<Widget> content) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Převzato z:',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12.0),
          ...content,
        ],
      );
}
