import 'package:dp_algebra/data/block_parser.dart';
import 'package:dp_algebra/data/db_helper.dart';
import 'package:dp_algebra/models/db/learn_block.dart';
import 'package:dp_algebra/models/db/learn_page.dart';
import 'package:dp_algebra/models/learn/block_content.dart';
import 'package:dp_algebra/widgets/layout/bullet_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class LPageView extends StatelessWidget {
  final LPage page;

  const LPageView({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (page.blocks.isEmpty) return const Text('Page is empty');
    return ListView.builder(
      itemCount: page.blocks.length,
      itemBuilder: (context, index) {
        LBlock block = page.blocks[index];

        List<LBlockContent> blockContent =
            BlockParser.parseBlock(block.content);

        List<List<Widget>> content = [];

        for (var part in blockContent) {
          if (part is LBlockParagraphContent) {
            content.addAll(_getParagraphContent(part.content, context));
          } else if (part is LBlockListContent) {
            List<List<Widget>> listContent = [];
            for (var row in part.content) {
              listContent.add(_getParagraphContent(row.content, context).first);
            }

            content.add([
              BulletList(
                items: listContent,
                enumerated: part.type == LBlockContentType.enumeratedList,
              )
            ]);
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: [
              if (block.type.title != null)
                Text(
                  block.type.title!,
                  style: Theme.of(context).textTheme.headline3,
                ),
              for (var row in content) _getBlockWrap(row)
            ],
          ),
        );
      },
    );
  }

  List<List<Widget>> _getParagraphContent(
      List<LBlockSegment> paragraphContent, BuildContext context) {
    List<List<Widget>> segments = [[]];

    for (var segment in paragraphContent) {
      if (segment.type == LBlockSegmentType.displayMath) segments.add([]);

      switch (segment.type) {
        case LBlockSegmentType.text:
          segments[segments.length - 1].add(Text(
            segment.content,
            style: Theme.of(context).textTheme.bodyText2,
          ));
          break;
        case LBlockSegmentType.inlineMath:
        case LBlockSegmentType.displayMath:
          segments[segments.length - 1].add(
            Math.tex(
              segment.content,
              textScaleFactor:
                  segment.type == LBlockSegmentType.displayMath ? 1.4 : 1.1,
              mathStyle: segment.type == LBlockSegmentType.displayMath
                  ? MathStyle.display
                  : MathStyle.text,
            ),
          );
          break;
        case LBlockSegmentType.reference:
          // TODO: replace with link to reference when references are implemented
          if ((segment as LBlockRefSegment).refType ==
              LBlockReferenceType.literature) {
            segments[segments.length - 1].add(
              FutureBuilder(
                future: DbHelper.findLiterature(segment.content),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData ||
                      snapshot.data == null) {
                    return const Text('(...)');
                  }

                  return Text(
                    snapshot.data!.getHarvardCitation(),
                    style: Theme.of(context).textTheme.bodyText2,
                  );
                },
              ),
            );
          } else {
            segments[segments.length - 1].add(
              Text(
                '[${segment.content}]',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            );
          }
          break;
      }

      if (segment.type == LBlockSegmentType.displayMath) segments.add([]);
    }

    return segments;
  }

  Widget _getBlockWrap(List<Widget> elements) => Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 8.0,
        children: elements,
      );
}
