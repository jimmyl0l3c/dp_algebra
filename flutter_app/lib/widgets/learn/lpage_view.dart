import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../data/block_parser.dart';
import '../../models/db/learn_block.dart';
import '../../models/db/learn_page.dart';
import '../../models/learn/block_content.dart';
import '../../models/learn/block_segment.dart';
import '../../models/learn/type_enums.dart';
import '../layout/bullet_list.dart';
import '../layout/display_math_wrap.dart';
import 'block_ref_button.dart';
import 'image_block.dart';
import 'literature_citation.dart';
import 'literature_reference.dart';

class LPageView extends StatelessWidget {
  final LPage page;
  final ScrollController? scrollController;

  const LPageView({
    super.key,
    required this.page,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    BlockParser parser = BlockParser();

    if (page.blocks.isEmpty) return const Text('Page is empty');
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
      controller: scrollController,
      itemCount: page.blocks.length,
      itemBuilder: (context, index) {
        LBlock block = page.blocks[index];
        bool isLastBlock = index == page.blocks.length - 1;

        if (block.typeCode == 'image') {
          var image = ImageBlock(block: block);

          if (isLastBlock) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                image,
                LiteratureCitation(
                  segment: LBlockLiteratureContent(
                    parser.usedLiterature.toList(),
                  ),
                )
              ],
            );
          }
          return image;
        }

        List<LBlockContent> blockContent = parser.parseBlock(
          block.content,
          isLastBlock: isLastBlock,
        );

        List<List<Widget>> content = [];

        for (var part in blockContent) {
          if (part is LBlockParagraphContent) {
            content.addAll(_getParagraphContent(part.content, context));
          } else if (part is LBlockListContent) {
            List<List<Widget>> listContent = [];
            for (var row in part.content) {
              var listItemContent = _getParagraphContent(row.content, context);
              listContent.add([for (var item in listItemContent) ...item]);
            }

            content.add([
              BulletList(
                items: listContent,
                enumerated: part.type == LBlockContentType.enumeratedList,
              )
            ]);
          } else if (part is LBlockLiteratureContent) {
            content.add([LiteratureCitation(segment: part)]);
          }
        }

        return Padding(
          // Padding of blocks
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: [
              if (block.showTypeTitle)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0, top: 12.0),
                  child: Text(
                    block.fullTitle,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              for (var row in content)
                Padding(
                  // Padding of paragraphs of a block
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _getBlockWrap(row),
                ),
            ],
          ),
        );
      },
    );
  }

  List<List<Widget>> _getParagraphContent(
      List<LBlockSegment> paragraphContent, BuildContext context) {
    final theme = Theme.of(context);
    List<List<Widget>> segments = [[]];

    for (var segment in paragraphContent) {
      // if (segment.content.trim().isEmpty) continue;
      if (segment.type == LBlockSegmentType.displayMath) segments.add([]);

      switch (segment.type) {
        case LBlockSegmentType.text:
          segments.last.addAll(segment.content.split(RegExp(r' (?=\S)')).map(
                (e) => Text(
                  '${e.trimRight().replaceAll('--', '\u2014')} ',
                  style: theme.textTheme.bodyMedium,
                ),
              ));
          break;
        case LBlockSegmentType.inlineMath:
          segments.last.add(
            Math.tex(
              segment.content,
              textScaleFactor: 1.2,
              mathStyle: MathStyle.text,
              textStyle: theme.textTheme.bodyMedium,
            ),
          );
          break;
        case LBlockSegmentType.displayMath:
          segments.last.add(
            DisplayMathWrap(content: segment.content),
          );
          break;
        case LBlockSegmentType.blockReference:
          segments.last.add(BlockRefButton(refName: segment.content));
          break;
        case LBlockSegmentType.literatureReference:
          if (segments.last.isEmpty) {
            // Citation on an empty line (it was probably inside display math)
            var previous = segments[segments.length - 2].removeLast();
            if (previous is DisplayMathWrap) {
              segments[segments.length - 2].add(
                DisplayMathWrap(
                  content: previous.content,
                  citation: LiteratureReference(
                    segment: segment,
                    scrollController: scrollController,
                  ),
                ),
              );
            } else {
              segments[segments.length - 2].add(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    previous,
                    LiteratureReference(
                      segment: segment,
                      scrollController: scrollController,
                    ),
                  ],
                ),
              );
            }
            continue;
          }

          if (segments.last.isNotEmpty && segments.last.last is Math) {
            segments.last.add(Text(' ', style: theme.textTheme.bodyMedium));
          }
          segments.last.add(
            LiteratureReference(
              segment: segment,
              scrollController: scrollController,
            ),
          );
          break;
        case LBlockSegmentType.tabular:
          if (segment is! LBlockTabularCellSegment || segment.cells.isEmpty) {
            continue;
          }
          segments.last.add(
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 50 * segment.width.toDouble(),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _getParagraphContent(segment.cells, context).first,
              ),
            ),
          );
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
